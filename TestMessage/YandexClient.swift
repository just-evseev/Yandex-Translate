//
//  YandexClient.swift
//  TestMessage
//
//  Created by Ilya on 01/12/2018.
//  Copyright © 2018 Ilya. All rights reserved.
//

import UIKit

protocol YandexClientTextSender {
    func sendTranslatedText(text: String, translatedText: String, lang: Language)
    func sendTextLang(text: String, lang: Language)
}

class YandexClient {
    private let translateSite = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    private let detectSite = "https://translate.yandex.net/api/v1.5/tr.json/detect"
    var textProtocol: YandexClientTextSender
    
    init(textProtocol: YandexClientTextSender) {
        self.textProtocol = textProtocol
    }
    
    func getMethod(textToTranslate: String, lang: Language) {
        guard let text = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL.forTranslate(text: text, lang: lang.langParameter) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let j = json as? [String : AnyObject] {
                    if let str = j["text"] as? [String], let translatedText = str.first?.removingPercentEncoding {
                        self.textProtocol.sendTranslatedText(text: textToTranslate, translatedText: translatedText, lang: lang)
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getLang(text: String, lang: Language) {
        guard let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL.forDetect(text: text) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let j = json as? [String : AnyObject] else { return }
                guard let str = j["lang"] as? String else { return }
                guard let lang = Language(rawValue: str) else { return }
                self.textProtocol.sendTextLang(text: text, lang: lang)
            } catch {
                print(error)
            }
        }.resume()
    }
}
