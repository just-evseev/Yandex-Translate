//
//  YandexClient.swift
//  TestMessage
//
//  Created by Ilya on 01/12/2018.
//  Copyright © 2018 Ilya. All rights reserved.
//

import Foundation

protocol TextSender {
    func sendTranslatedText(text: String, translatedText: String, lang: String)
    func sendTextLang(text: String, lang: String)
}

class YandexClient {
    let APIKey = "trnsl.1.1.20181129T035043Z.123cb5af06d92209.5791edfbdd45a731dbdd0d86265a361cf914f63a"
    let translateSite = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    let detectSite = "https://translate.yandex.net/api/v1.5/tr.json/detect"
    var textProtocol: TextSender?
    
    func getMethod(textToTranslate: String, lang: String) {
        var translatedText = "hello"
        let textToTranslateURL = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let translateLang: String
        if (lang == "en") {
            translateLang = lang + "-ru"
        } else {
            translateLang = lang + "-en"
        }
        guard let url = URL(string: "\(translateSite)?key=\(APIKey)&text=\(textToTranslateURL!)&lang=\(translateLang)") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let j = json as? [String : AnyObject] {
                    if let str = j["text"] as? [String] {
                        translatedText = str[0]
                        translatedText = translatedText.removingPercentEncoding!
                        self.textProtocol?.sendTranslatedText(text: textToTranslate, translatedText: translatedText, lang: lang)
                    }
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func getLang(text: String, lang: Bool) {
        let textToGetLang = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: "\(detectSite)?key=\(APIKey)&text=\(textToGetLang!)&hint=ru,en") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let j = json as? [String : AnyObject] {
                    if let str = j["lang"] as? String {
                        if (str == "en" || str == "ru") {
                            self.textProtocol?.sendTextLang(text: text, lang: str)
                        } else {
                            self.textProtocol?.sendTextLang(text: text, lang: lang ? "en" : "ru")
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
