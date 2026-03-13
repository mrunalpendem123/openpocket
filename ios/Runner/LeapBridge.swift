import Foundation
import Flutter
import LeapSDK

class LeapBridge: NSObject {
    private let channel: FlutterMethodChannel
    private var audioRunner: ModelRunner?
    private var textRunner: ModelRunner?
    private var audioConversation: Conversation?
    private var textConversation: Conversation?
    private var downloadProgress: [String: Double] = [:]

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "com.openpocket/leap", binaryMessenger: messenger)
        super.init()
        channel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "loadModel":
            loadModel(call: call, result: result)
        case "transcribe":
            transcribe(call: call, result: result)
        case "summarize":
            summarize(call: call, result: result)
        case "chat":
            chat(call: call, result: result)
        case "isModelDownloaded":
            isModelDownloaded(call: call, result: result)
        case "getDownloadProgress":
            getDownloadProgress(call: call, result: result)
        case "downloadModel":
            downloadModel(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Model Loading

    private func loadModel(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        Task {
            do {
                if modelType == "audio" {
                    let runner = try await Leap.load(
                        model: "LFM2-Audio-1.5B",
                        quantization: "Q5_K_M"
                    )
                    self.audioRunner = runner
                    self.audioConversation = runner.createConversation(
                        systemPrompt: "Transcribe the following audio accurately."
                    )
                } else {
                    let runner = try await Leap.load(
                        model: "LFM2-2.6B-Transcript",
                        quantization: "Q5_K_M"
                    )
                    self.textRunner = runner
                    self.textConversation = runner.createConversation(
                        systemPrompt: "You are a helpful assistant that summarizes conversation transcripts and answers questions."
                    )
                }

                DispatchQueue.main.async {
                    result(true)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "LOAD_FAILED",
                        message: "Failed to load \(modelType) model: \(error.localizedDescription)",
                        details: nil
                    ))
                }
            }
        }
    }

    // MARK: - Transcription

    private func transcribe(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let audioData = args["audioData"] as? FlutterStandardTypedData else {
            result(FlutterError(code: "INVALID_ARGS", message: "audioData required", details: nil))
            return
        }

        guard let conversation = audioConversation else {
            result(FlutterError(code: "MODEL_NOT_LOADED", message: "Audio model not loaded. Call loadModel first.", details: nil))
            return
        }

        let language = args["language"] as? String ?? "en"

        Task {
            do {
                let message = ChatMessage(
                    role: .user,
                    content: [
                        .text("Transcribe this audio in \(language):"),
                        .audio(audioData.data)
                    ]
                )

                var fullText = ""
                for try await response in conversation.generateResponse(message: message) {
                    switch response {
                    case .chunk(let delta):
                        fullText += delta
                    case .complete(let completion):
                        for item in completion.message.content {
                            if case .text(let t) = item {
                                fullText = t
                                break
                            }
                        }
                    default:
                        break
                    }
                }

                DispatchQueue.main.async {
                    result(fullText)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "TRANSCRIBE_FAILED",
                        message: "Transcription failed: \(error.localizedDescription)",
                        details: nil
                    ))
                }
            }
        }
    }

    // MARK: - Summarization

    private func summarize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let transcript = args["transcript"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "transcript required", details: nil))
            return
        }

        guard let conversation = textConversation else {
            result(FlutterError(code: "MODEL_NOT_LOADED", message: "Text model not loaded. Call loadModel first.", details: nil))
            return
        }

        Task {
            do {
                let prompt = """
                Summarize this conversation transcript. Respond with JSON only:
                {"title": "...", "overview": "...", "actionItems": ["..."]}

                Transcript:
                \(transcript)
                """

                let message = ChatMessage(role: .user, content: [.text(prompt)])
                var fullText = ""
                for try await response in conversation.generateResponse(message: message) {
                    switch response {
                    case .chunk(let delta):
                        fullText += delta
                    case .complete(let completion):
                        for item in completion.message.content {
                            if case .text(let t) = item {
                                fullText = t
                                break
                            }
                        }
                    default:
                        break
                    }
                }

                DispatchQueue.main.async {
                    result(fullText)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "SUMMARIZE_FAILED",
                        message: "Summarization failed: \(error.localizedDescription)",
                        details: nil
                    ))
                }
            }
        }
    }

    // MARK: - Chat

    private func chat(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let userMessage = args["message"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "message required", details: nil))
            return
        }

        guard let conversation = textConversation else {
            result(FlutterError(code: "MODEL_NOT_LOADED", message: "Text model not loaded. Call loadModel first.", details: nil))
            return
        }

        Task {
            do {
                let message = ChatMessage(role: .user, content: [.text(userMessage)])
                var fullText = ""
                for try await response in conversation.generateResponse(message: message) {
                    switch response {
                    case .chunk(let delta):
                        fullText += delta
                    case .complete(let completion):
                        for item in completion.message.content {
                            if case .text(let t) = item {
                                fullText = t
                                break
                            }
                        }
                    default:
                        break
                    }
                }

                DispatchQueue.main.async {
                    result(fullText)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "CHAT_FAILED",
                        message: "Chat failed: \(error.localizedDescription)",
                        details: nil
                    ))
                }
            }
        }
    }

    // MARK: - Model Management

    private func isModelDownloaded(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        // If runner is already loaded, model is available
        if modelType == "audio" && audioRunner != nil {
            result(true)
            return
        }
        if modelType == "text" && textRunner != nil {
            result(true)
            return
        }

        // Check LEAP SDK cache directory
        let modelName = modelType == "audio" ? "LFM2-Audio-1.5B" : "LFM2-2.6B-Transcript"
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let leapDir = cacheDir.appendingPathComponent("ai.liquid.LeapSDK/models/\(modelName)")
        let exists = FileManager.default.fileExists(atPath: leapDir.path)
        result(exists)
    }

    private func getDownloadProgress(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        if modelType == "audio" && audioRunner != nil {
            result(1.0)
        } else if modelType == "text" && textRunner != nil {
            result(1.0)
        } else {
            result(downloadProgress[modelType] ?? 0.0)
        }
    }

    private func downloadModel(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        let modelName = modelType == "audio" ? "LFM2-Audio-1.5B" : "LFM2-2.6B-Transcript"

        Task {
            do {
                // Leap.load() downloads the model automatically if not cached
                let runner = try await Leap.load(
                    model: modelName,
                    quantization: "Q5_K_M",
                    downloadProgressHandler: { [weak self] progress, speed in
                        guard let self = self else { return }
                        self.downloadProgress[modelType] = progress
                        DispatchQueue.main.async {
                            self.channel.invokeMethod("onDownloadProgress", arguments: [
                                "modelType": modelType,
                                "progress": progress
                            ])
                        }
                    }
                )

                if modelType == "audio" {
                    self.audioRunner = runner
                    self.audioConversation = runner.createConversation(
                        systemPrompt: "Transcribe the following audio accurately."
                    )
                } else {
                    self.textRunner = runner
                    self.textConversation = runner.createConversation(
                        systemPrompt: "You are a helpful assistant that summarizes conversation transcripts and answers questions."
                    )
                }

                self.downloadProgress[modelType] = 1.0

                DispatchQueue.main.async {
                    self.channel.invokeMethod("onDownloadProgress", arguments: [
                        "modelType": modelType,
                        "progress": 1.0
                    ])
                    result(true)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "DOWNLOAD_FAILED",
                        message: "Failed to download \(modelType) model: \(error.localizedDescription)",
                        details: nil
                    ))
                }
            }
        }
    }
}
