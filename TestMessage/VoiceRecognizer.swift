//
//  VoiceRecognizer.swift
//  TestMessage
//
//  Created by Ilya on 03/12/2018.
//  Copyright © 2018 Ilya. All rights reserved.
//

import UIKit
import Speech

protocol AlertProtocol {
    func sendAlert(message: String)
}

class VoiseRecognizer: NSObject, SFSpeechRecognizerDelegate {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    var alertProtocol: AlertProtocol?
    
    func voiceRecognizeStart() {
        recordAndRecognizeSpeech()
    }
    
    func voiceRecognizeStop() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                case .denied:
                    print("User denied access to speech recognition")
                    break
                case .restricted:
                    print("Speech recognition restricted on this device")
                    break
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                    break
                }
            }
        }
    }
    
    func recordAndRecognizeSpeech() {
        requestSpeechAuthorization()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.alertProtocol!.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.alertProtocol!.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.alertProtocol!.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.alertProtocol!.sendAlert(message: bestString)
            } else if let error = error {
                self.alertProtocol!.sendAlert(message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
}
