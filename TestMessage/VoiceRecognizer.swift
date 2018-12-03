//
//  VoiceRecognizer.swift
//  TestMessage
//
//  Created by Ilya on 03/12/2018.
//  Copyright © 2018 Ilya. All rights reserved.
//

import UIKit
import Speech

class VoiseRecognizer: NSObject, SFSpeechRecognizerDelegate, ActionButtonDelegate {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    func voiceRecognizeStart() {
        
    }
    
    func voiceRecognizeStop() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized: break
//                    self.startButton.isEnabled = true
                case .denied: break
//                    self.startButton.isEnabled = false
//                    self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted: break
//                    self.startButton.isEnabled = false
//                    self.detectedTextLabel.text = "Speech recognition restricted on this device"
                case .notDetermined: break
//                    self.startButton.isEnabled = false
//                    self.detectedTextLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
    
//    func recordAndRecognizeSpeech() {
//        guard var node = audioEngine.inputNode else { return }
//        let recordingFormat = node.outputFormat(forBus: 0)
//        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            self.request.append(buffer)
//        }
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            self.sendAlert(message: "There has been an audio engine error.")
//            return print(error)
//        }
//        guard let myRecognizer = SFSpeechRecognizer() else {
//            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
//            return
//        }
//        if !myRecognizer.isAvailable {
//            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
//            // Recognizer is not available right now
//            return
//        }
//        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
//            if let result = result {
//                
//                let bestString = result.bestTranscription.formattedString
////                self.detectedTextLabel.text = bestString
//                
//                var lastString: String = ""
//                for segment in result.bestTranscription.segments {
//                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
//                    lastString = bestString.substring(from: indexTo)
//                }
////                self.checkForColorsSaid(resultString: lastString)
//            } else if let error = error {
//                self.sendAlert(message: "There has been a speech recognition error.")
//                print(error)
//            }
//        })
//    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
}
