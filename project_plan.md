# Project Plan: On-Device AI Note-Taking Wearable App

## Project Overview

Build a privacy-first, fully offline AI note-taking system consisting of:
1. A forked Flutter iOS app (based on Omi) with cloud backend replaced by on-device Liquid AI model
2. A cheap custom BLE hardware wearable (ESP32 + MEMS mic) that streams audio to the phone

**Core philosophy**: Zero cloud. Everything runs on-device. Audio never leaves the phone.

---

## Architecture Overview

```
[ESP32 Hardware Device]
  └── MEMS Microphone (INMP441)
  └── BLE 5.0 chip
  └── Opus audio encoder (firmware)
        │
        │ Bluetooth Low Energy (audio bytes stream)
        ▼
[iPhone App - Flutter]
  └── BLE Manager (flutter_blue_plus)
  └── Audio Decoder (Opus → PCM)
  └── LFM2.5-Audio-1.5B (via LEAP SDK - on device)
        └── ASR: Speech → Transcript
        └── LFM2-2.6B-Transcript (via LEAP SDK - on device)
              └── Transcript → Structured Notes, Action Items, Key Points
  └── Local Storage (SQLite / Hive)
  └── UI (forked from Omi Flutter app)
```

---

## Phase 1: Flutter App Setup (Fork Omi)

### 1.1 Fork and Clone
```bash
git clone https://github.com/BasedHardware/omi.git
cd omi/app
```

### 1.2 Things to KEEP from Omi
- `/app/lib/ui/` — all UI screens and widgets
- `/app/lib/services/devices/` — BLE connection logic
- `/app/lib/services/devices/device_connection.dart` — BLE audio streaming
- `/app/lib/backend/schema/bt_device/` — BLE device models
- BLE scanning, pairing, and audio characteristic subscription code
- Conversation list UI, transcript display UI
- `flutter_blue_plus` dependency

### 1.3 Things to REMOVE / REPLACE from Omi
- Firebase (Auth, Firestore, Storage) — remove entirely
- Deepgram API calls — replace with LEAP local model
- OpenAI API calls — replace with LEAP local model
- Pinecone vector DB — remove
- Redis — remove
- All `backend/http/` API calls to Omi's cloud backend
- `.env` file with API keys — not needed

### 1.4 Dependencies to Add (pubspec.yaml)
```yaml
dependencies:
  flutter_blue_plus: ^1.x.x        # BLE connection (already in Omi)
  opus_dart: ^latest                # Opus audio decoding
  opus_flutter: ^latest             # Opus for Flutter
  hive: ^2.x.x                     # Local storage (replace Firestore)
  hive_flutter: ^latest
  path_provider: ^latest
  permission_handler: ^latest
  flutter_foreground_task: ^latest  # Keep BLE alive when app backgrounded
```

Note: LEAP SDK is integrated via Swift Package Manager in the iOS native layer,
not as a Flutter pub package. See Phase 2 for native integration details.

---

## Phase 2: LEAP SDK Integration (Native iOS Bridge)

The Liquid AI LEAP SDK is a native Swift SDK. You need to bridge it to Flutter
using Platform Channels.

### 2.1 Add LEAP SDK to iOS project
In Xcode (`app/ios`):
- File → Add Package Dependencies
- Add: `https://github.com/Liquid4All/leap-ios.git`
- Add `LeapSDK` and `LeapModelDownloader` to Runner target

### 2.2 Create Swift Platform Channel (AppDelegate.swift or new plugin)

Create `app/ios/Runner/LeapBridge.swift`:

```swift
import Flutter
import LeapSDK
import LeapModelDownloader

class LeapBridge: NSObject {
    private var modelRunner: ModelRunner?
    private var channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "com.yourapp/leap",
            binaryMessenger: messenger
        )
        super.init()
        channel.setMethodCallHandler(handle)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "loadModel":
            loadModel(result: result)
        case "transcribe":
            let args = call.arguments as! [String: Any]
            let audioBytes = args["audioBytes"] as! FlutterStandardTypedData
            transcribe(audioData: audioBytes.data, result: result)
        case "summarize":
            let args = call.arguments as! [String: Any]
            let text = args["text"] as! String
            summarize(text: text, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func loadModel(result: @escaping FlutterResult) {
        Task {
            // Downloads LFM2.5-Audio-1.5B on first launch (~845MB)
            // Cached after first download
            let modelRunner = try await ModelRunner(
                modelName: "LFM2.5-Audio-1.5B-Q4_0"
            )
            self.modelRunner = modelRunner
            result("loaded")
        }
    }

    func transcribe(audioData: Data, result: @escaping FlutterResult) {
        Task {
            guard let runner = modelRunner else {
                result(FlutterError(code: "NOT_LOADED", message: "Model not loaded", details: nil))
                return
            }
            // Run ASR on audio bytes
            let transcript = try await runner.transcribe(audio: audioData)
            result(transcript)
        }
    }

    func summarize(text: String, result: @escaping FlutterResult) {
        Task {
            guard let runner = modelRunner else {
                result(FlutterError(code: "NOT_LOADED", message: "Model not loaded", details: nil))
                return
            }
            let summary = try await runner.chat(
                messages: [
                    ["role": "system", "content": "You are a note-taking assistant. Summarize the transcript into clean, structured notes with key points and action items."],
                    ["role": "user", "content": text]
                ]
            )
            result(summary)
        }
    }
}
```

Register in AppDelegate.swift:
```swift
let leapBridge = LeapBridge(messenger: flutterViewController.binaryMessenger)
```

### 2.3 Dart side — LeapService

Create `app/lib/services/leap_service.dart`:

```dart
import 'package:flutter/services.dart';

class LeapService {
  static const _channel = MethodChannel('com.yourapp/leap');

  Future<void> loadModel() async {
    await _channel.invokeMethod('loadModel');
  }

  Future<String> transcribe(Uint8List audioBytes) async {
    return await _channel.invokeMethod('transcribe', {
      'audioBytes': audioBytes,
    });
  }

  Future<String> summarize(String transcript) async {
    return await _channel.invokeMethod('summarize', {
      'text': transcript,
    });
  }
}
```

---

## Phase 3: BLE Audio Pipeline

This replaces Omi's cloud transcription with local LEAP transcription.

### 3.1 Audio flow in Omi (what to keep)
Omi's existing code already handles:
- Scanning for BLE devices
- Connecting to device via `flutter_blue_plus`
- Subscribing to audio characteristic UUID
- Receiving Opus-encoded audio bytes as `List<int>` stream

Keep all of this intact. Just change what happens to the bytes after receiving them.

### 3.2 Replace cloud call with local model

Find in Omi's code where audio bytes are sent to Deepgram/cloud.
Replace that call with:

```dart
// OLD (remove this):
// await DeepgramService.transcribe(audioBytes);

// NEW (replace with):
final leapService = LeapService();
final audioUint8 = Uint8List.fromList(audioBytes);
final transcript = await leapService.transcribe(audioUint8);
```

### 3.3 Audio buffering strategy
Don't transcribe every BLE packet — buffer audio:
- Collect audio chunks for ~10-15 seconds of speech
- Detect silence (pause > 1.5 seconds) as a segment boundary
- Then run transcription on the complete segment
- Append result to the live transcript

### 3.4 BLE UUIDs for custom hardware
When you build your own ESP32 hardware, define your own UUIDs:
```dart
const String AUDIO_SERVICE_UUID = '19B10000-E8F2-537E-4F6C-D104768A1214';
const String AUDIO_STREAM_UUID  = '19B10001-E8F2-537E-4F6C-D104768A1214';
```
These must match exactly what you flash in the ESP32 firmware.

---

## Phase 4: Local Storage (Replace Firebase)

### 4.1 Use Hive instead of Firestore

Create `app/lib/services/storage_service.dart`:

```dart
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static late Box<Map> _conversationsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _conversationsBox = await Hive.openBox<Map>('conversations');
  }

  Future<void> saveConversation({
    required String id,
    required String transcript,
    required String summary,
    required DateTime timestamp,
  }) async {
    await _conversationsBox.put(id, {
      'transcript': transcript,
      'summary': summary,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  List<Map> getAllConversations() {
    return _conversationsBox.values.toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
  }
}
```

### 4.2 Remove all Firebase imports
Search for and delete:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
from pubspec.yaml and all dart files.

---

## Phase 5: First Launch Model Download UX

On first app open, show a download screen before anything else.

Create `app/lib/ui/screens/model_download_screen.dart`:

```dart
class ModelDownloadScreen extends StatefulWidget { ... }

// Show:
// - App logo
// - "Setting up your private AI" title
// - Progress bar (track download via LEAP's ModelDownloader callbacks)
// - "Downloading AI model (845 MB) — one time only"
// - "Your audio will never leave your device"
// - ETA timer

// On complete → navigate to main home screen
// Store flag in SharedPreferences: 'model_downloaded' = true
// Check this flag on every app launch to skip download screen
```

---

## Phase 6: Hardware — ESP32 BLE Wearable

### 6.1 Components (target BOM < $15)
| Component | Part | Source | Est. Cost |
|---|---|---|---|
| Microcontroller | ESP32-S3 mini | AliExpress / LCSC | ~$3 |
| MEMS Microphone | INMP441 (I2S) | AliExpress | ~$1 |
| Battery | 3.7V 150mAh LiPo | AliExpress | ~$2 |
| Charging IC | TP4054 | LCSC | ~$0.20 |
| PCB manufacturing | JLCPCB (5 pcs) | jlcpcb.com | ~$2 |
| Misc (caps, resistors) | — | LCSC | ~$1 |
| **Total** | | | **~$9–10** |

### 6.2 Reference design
Use Omi's open-source schematic as base:
- Repo: `github.com/BasedHardware/omi`
- Hardware files: `/hardware/` folder in the repo
- Omi uses nRF52840 — you can substitute ESP32-S3 (cheaper, same BLE 5.0)

### 6.3 Firmware (ESP32 Arduino / Zephyr)
Key firmware tasks:
1. Initialize I2S mic (INMP441)
2. Capture audio at 16kHz, 16-bit mono
3. Encode with Opus codec (use `libopus` port for ESP32)
4. Advertise over BLE with your custom Service UUID
5. Stream encoded audio bytes to the audio characteristic
6. Low-power sleep when not connected

Reference firmware repo: `github.com/BasedHardware/omi` → `/firmware/` folder

### 6.4 BLE Packet Structure
```
[2 bytes: packet index] [N bytes: opus encoded audio frame]
```
Match this exactly in the Flutter BLE receiver.

---

## Phase 7: App UI Changes (on top of Omi)

Keep Omi's existing UI for:
- Conversation list screen
- Live transcript screen
- Settings screen
- BLE device connection screen

Add / modify:
- **Home screen**: Remove Omi branding, add your own
- **Model download screen**: New (Phase 5)
- **Settings**: Remove all cloud/API key settings. Add "Storage used", "Clear all data"
- **Conversation detail**: Show both raw transcript + AI summary side by side

---

## Phase 8: iOS Permissions (Info.plist)

Add to `ios/Runner/Info.plist`:
```xml
<!-- Bluetooth -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Used to connect to your wearable device</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Used to connect to your wearable device</string>

<!-- Background BLE (keep connection alive) -->
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
</array>

<!-- Microphone (for phone-only mode without hardware) -->
<key>NSMicrophoneUsageDescription</key>
<string>Used to record audio when no wearable is connected</string>
```

---

## File Structure After Changes

```
omi/app/lib/
├── main.dart
├── services/
│   ├── devices/              ← KEEP (BLE logic)
│   │   ├── device_connection.dart
│   │   └── models.dart
│   ├── leap_service.dart     ← NEW (LEAP bridge)
│   └── storage_service.dart  ← NEW (Hive, replaces Firebase)
├── ui/
│   ├── screens/
│   │   ├── model_download_screen.dart  ← NEW
│   │   ├── home_screen.dart            ← MODIFY (remove cloud UI)
│   │   ├── conversation_screen.dart    ← KEEP + MODIFY
│   │   └── settings_screen.dart        ← MODIFY
│   └── widgets/              ← KEEP
└── backend/
    └── schema/
        └── bt_device/        ← KEEP
```

```
omi/app/ios/Runner/
├── AppDelegate.swift          ← MODIFY (register LeapBridge)
├── LeapBridge.swift           ← NEW
└── Info.plist                 ← MODIFY (add permissions)
```

---

## Build Order / Sequence for Claude Code

Work in this exact order:

1. **Clone Omi repo** and get it running locally as-is first
2. **Strip Firebase** — remove all firebase packages and fix compile errors
3. **Add Hive** — implement StorageService, make app compile and run
4. **Add LEAP SDK** in Xcode — create LeapBridge.swift, test model loads
5. **Create LeapService.dart** — test platform channel works end to end
6. **Replace Deepgram/cloud calls** with LeapService.transcribe()
7. **Add model download screen** — first launch flow
8. **Clean up UI** — remove Omi branding, cloud settings, unused screens
9. **Test on real iPhone** — LEAP requires physical device (not simulator)
10. **Hardware** — once app works with phone mic, move to ESP32 firmware

---

## Key Links & References

| Resource | URL |
|---|---|
| Omi app repo | github.com/BasedHardware/omi |
| LEAP iOS SDK | github.com/Liquid4All/leap-ios |
| LEAP docs | docs.liquid.ai/leap/edge-sdk/ios/ios-quick-start-guide |
| LFM2.5-Audio-1.5B (transcription) | huggingface.co/LiquidAI/LFM2.5-Audio-1.5B-GGUF-LEAP |
| LFM2-2.6B-Transcript (summarization) | huggingface.co/LiquidAI/LFM2-2.6B-Transcript |
| Meeting summarization cookbook example | github.com/Liquid4All/cookbook/tree/main/examples/meeting-summarization |
| Liquid AI cookbook | github.com/Liquid4All/cookbook |
| Omi hardware schematics | github.com/BasedHardware/omi/tree/main/hardware |
| JLCPCB (PCB manufacturing) | jlcpcb.com |
| LCSC (components) | lcsc.com |

---

## Notes for Claude Code

- **Always test on a real iPhone**, not simulator — LEAP model won't run on simulator
- **Two models to download on first launch**:
  - LFM2.5-Audio-1.5B (~845 MB) — transcription
  - LFM2-2.6B-Transcript (~1.5 GB at Q4) — summarization
  - Total first-launch download: ~2.3 GB (cached after that)
- **LFM2-2.6B-Transcript system prompt** (use exactly as recommended by Liquid AI):
  `"You are an expert meeting analyst."`
- **LFM2-2.6B-Transcript temperature**: Use `temperature=0.3` as recommended
- Minimum iPhone spec: iOS 15.0+, 3GB RAM (iPhone XS or newer)
- BLE audio streaming and LEAP inference can run simultaneously — BLE is low CPU
- Opus decoding must happen before passing audio to LEAP (raw PCM input expected)
- Keep the Omi BLE UUID constants — they work with Omi hardware if you want to test before building custom hardware
- Use `flutter run --flavor dev` to run the app in dev mode
