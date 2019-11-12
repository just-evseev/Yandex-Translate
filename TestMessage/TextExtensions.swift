extension String {
    static var forTranslateURL = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    static var forDetectURL = "https://translate.yandex.net/api/v1.5/tr.json/detect"
    static var APIKey: String {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else { return "" }
        guard let api = NSDictionary(contentsOfFile: path)?["yandexAPIKey"] as? String else { return "" }
        return api
    }
}

extension URL {
    static func forTranslate(text: String, lang parameter: String) -> URL? {
        return URL(string: "\(String.forTranslateURL)?key=\(String.APIKey)&text=\(text)&lang=\(parameter)")
    }
    static func forDetect(text: String) -> URL? {
        return URL(string: "\(String.forTranslateURL)?key=\(String.APIKey)&text=\(text)&hint=ru,en")
    }
}
