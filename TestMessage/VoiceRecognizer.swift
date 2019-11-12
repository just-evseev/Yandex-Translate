import UIKit
import Speech

protocol AlertProtocol {
    func sendAlert(message: String)
}

protocol VoiceRecognizeText {
    func getText(text: String)
}

class VoiseRecognizer: NSObject, SFSpeechRecognizerDelegate {
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))! //ru_RU
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var alertProtocol: AlertProtocol?
    var voiseRecognizeTextProtocol: VoiceRecognizeText?
    
    private let BUFFER_SIZE: AVAudioFrameCount = 1024
    
    override init() {
        super.init()
        
        speechRecognizer.delegate = self
        requestSpeechAuthorization()
    }
    
    func voiceRecognizeStart(lang: Bool) {
        var lang: String { return lang ? "en-US" : "ru_RU" }
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: lang)) else { return }
        self.speechRecognizer = speechRecognizer
        do {
            try startRecording()
        } catch {
            print("error in recording")
        }
    }
    
    func voiceRecognizeStop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    private func startRecording() throws {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = false
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: BUFFER_SIZE, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                let str = result.bestTranscription.formattedString
                if (str != "") {
                    self.voiseRecognizeTextProtocol?.getText(text: str)
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                if !isFinal {
                    print("Got error in recogn")
                }
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                print("Speech recognition status = \(authStatus)")
            }
        }
    }
}
