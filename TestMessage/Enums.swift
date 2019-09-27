//
//  Enums.swift
//  TestMessage
//
//  Created by Ilya on 27/09/2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit

///Язык и его параметры
enum Language {
    case rus, eng
    
    ///Имя языка
    var name: String {
        switch self {
        case .rus: return "Русский"
        case .eng: return "Английский"
        }
    }
    
    ///Картинка, используемая для выбранного языка
    var image: UIImage {
        switch self {
        case .rus: return UIImage(named: "rusFlag") ?? UIImage()
        case .eng: return UIImage(named: "engFlag") ?? UIImage()
        }
    }
}

///Перечесоение в котором есть выбранные языки, содержит в себе информацию о выбранном языке для кастомизации View
enum FlagsPosition {
    case engFirst, rusFirst
    
    ///Константа для Constraintов флажков
    var constraintConstant: CGFloat {
        switch self {
        case .rusFirst: return 12
        case .engFirst: return 2
        }
    }
    
    ///Placehilder text для UITextField
    var placeholderText: NSAttributedString {
        switch self {
        case .rusFirst: return NSAttributedString(string: Language.rus.name, attributes: [.foregroundColor: UIColor.grayYandex, .font: UIFont.placeholderFont])
        case .engFirst: return NSAttributedString(string: Language.eng.name, attributes: [.foregroundColor: UIColor.grayYandex, .font: UIFont.placeholderFont])
        }
    }
    
    ///Цвет всей вьюхи при выбранном языке
    var backgroundColor: UIColor {
        switch self {
        case .rusFirst: return .redYandex
        case .engFirst: return .blueYandex
        }
    }
    
    ///Выбранный язык соответствующий режиму
    var selectedLanguage: Language {
        switch self {
        case .rusFirst: return .rus
        case .engFirst: return .eng
        }
    }
    
    ///При смене языка следующий по списку язык - возвращаемый
    var nextPosition: FlagsPosition {
        switch self {
        case .rusFirst: return .engFirst
        case .engFirst: return .rusFirst
        }
    }
}

enum ActionButtonPosition {
    case startRec, endRec, sendMessage
    
    ///UIimage для кнопки 
    var image: UIImage {
        switch self {
        case .startRec: return .microphoneImage
        case .endRec: return .endRecImage
        case .sendMessage: return .sendTextImage
        }
    }
}
