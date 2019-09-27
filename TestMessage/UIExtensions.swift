import UIKit

extension UIFont {
    ///Шрифт для текст отправленного пользователем
    static let personFont = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
    ///Шрифт для переведенного текста
    static let translatedFont = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)
    ///Шрифт для placeholder текст в UITextField поля ввода
    static var placeholderFont = UIFont.systemFont(ofSize: 17, weight: .medium)
    ///Шрифт для вводимого в UITextField текста
    static var textFieldFont = UIFont.systemFont(ofSize: 17, weight: .medium)
}

extension UIColor {
    static let blueYandex = UIColor(red: 0/255, green: 124/255, blue: 233/255, alpha: 1.0)
    static let redYandex = UIColor(red: 237/255, green: 76/255, blue: 92/255, alpha: 1.0)
    static let whiteYandex = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    static let grayYandex = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 0.8)
}

extension UIImage {
    static var microphoneImage: UIImage {
        return UIImage(named: "microphone") ?? UIImage.init(systemName: "mic.fill") ?? UIImage()
    }
    static var clearImage: UIImage {
        return UIImage(named: "clearText") ?? UIImage()
    }
    static var endRecImage: UIImage {
        return UIImage(named: "startVoice") ?? UIImage()
    }
    static var sendTextImage: UIImage {
        return UIImage(named: "sendMsg") ?? UIImage()
    }
}
