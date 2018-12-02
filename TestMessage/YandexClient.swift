//
//  YandexClient.swift
//  TestMessage
//
//  Created by Ilya on 01/12/2018.
//  Copyright © 2018 Ilya. All rights reserved.
//

import Foundation

class YandexClient {
    let APIKey = "trnsl.1.1.20181129T035043Z.123cb5af06d92209.5791edfbdd45a731dbdd0d86265a361cf914f63a"
    let site = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    var ui = "en"
    
//    init() {
//
//    }
    
    func getMethod(textToTranslate: String, lang: Bool) -> String {
        ui = lang ? "ru" : "en"
        var translatedText = "hello"
        let textToTranslateURL = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(textToTranslateURL!)
        guard let url = URL(string: "\(site)?key=\(APIKey)&text=\(textToTranslateURL!)&lang=\(ui)") else { return "error in url" }
        
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
                    }
                }
            } catch {
                print(error)
            }
            }.resume()
        return translatedText
    }
    
}
