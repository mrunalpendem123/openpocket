import Foundation
import Flutter
// Note: LEAP SDK import will be added when SPM package is configured
// import LEAPSDK

class LeapBridge: NSObject {
    private let channel: FlutterMethodChannel
    // private var audioModel: LEAPModel?
    // private var textModel: LEAPModel?

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

    private func loadModel(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        // TODO: Initialize LEAP model based on type
        // modelType: "audio" for LFM2.5-Audio-1.5B, "text" for LFM2-2.6B-Transcript
        // let config = LEAPModelConfig(...)
        // if modelType == "audio" { audioModel = LEAPModel(config) }
        // else { textModel = LEAPModel(config) }

        result(true)
    }

    private func transcribe(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let audioData = args["audioData"] as? FlutterStandardTypedData else {
            result(FlutterError(code: "INVALID_ARGS", message: "audioData required", details: nil))
            return
        }

        let language = args["language"] as? String ?? "en"

        // TODO: Call LEAP audio model for transcription
        // guard let audioModel = audioModel else {
        //     result(FlutterError(code: "MODEL_NOT_LOADED", message: "Audio model not loaded", details: nil))
        //     return
        // }
        // let transcription = audioModel.transcribe(audioData.data, language: language)
        // result(transcription.text)

        // Placeholder until LEAP SDK is configured via SPM
        result("")
    }

    private func summarize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let transcript = args["transcript"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "transcript required", details: nil))
            return
        }

        // TODO: Call LEAP text model for summarization
        // guard let textModel = textModel else {
        //     result(FlutterError(code: "MODEL_NOT_LOADED", message: "Text model not loaded", details: nil))
        //     return
        // }
        // let prompt = "Summarize this conversation transcript. Provide a title, overview, and action items:\n\n\(transcript)"
        // let summary = textModel.generate(prompt)
        // result(summary)

        // Placeholder
        result("{\"title\": \"Conversation\", \"overview\": \"Transcript recorded.\", \"actionItems\": []}")
    }

    private func isModelDownloaded(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        let modelDir = getModelDirectory(for: modelType)
        let exists = FileManager.default.fileExists(atPath: modelDir.path)
        result(exists)
    }

    private func getDownloadProgress(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let _ = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        // TODO: Track download progress from LEAP SDK
        result(0.0)
    }

    private func downloadModel(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelType = args["modelType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "modelType required", details: nil))
            return
        }

        // TODO: Trigger LEAP model download
        // LEAPModelDownloader.download(modelType) { progress in
        //     self.channel.invokeMethod("onDownloadProgress", arguments: [
        //         "modelType": modelType,
        //         "progress": progress
        //     ])
        // } completion: { success in
        //     result(success)
        // }

        result(true)
    }

    private func getModelDirectory(for modelType: String) -> URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDir.appendingPathComponent("leap_models/\(modelType)")
    }
}
