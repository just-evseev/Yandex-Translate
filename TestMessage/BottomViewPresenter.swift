//
//  BottomViewPresenter.swift
//  TestMessage
//
//  Created by ilya on 28/08/2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit

protocol BottomViewPresenterProtocol: class {
    ///Меняем язык
    func changeLang()
    ///Нажали на action button
    func clickAction()
    ///Нажали на кнопку очистить поле ввода
    func clickClear()
    ///Текст поменялся
    func editText()
    /// - Returns: Какой язык сейчас выбран?
    func getLang() -> Language
}

protocol BottomViewParentPresenterProtocol: class {
    func stopEditing()
}

class BottomViewPresenter {
    ///Вью нашего презентера
    weak var view: BottomViewProtocol? {
        didSet {
            view?.changeActionButton(with: actionPosition)
        }
    }
    ///Выбранный язык (изначально - английский)
    private var flagPosition: FlagsPosition {
        didSet {
            view?.changeLang(with: flagPosition)
        }
    }
    ///Актуальное состояние actionButton (по умолчанию - Начать запись)
    private var actionPosition: ActionButtonPosition {
        didSet {
            view?.changeActionButton(with: actionPosition)
        }
    }
    
    init() {
        flagPosition = .engFirst
        actionPosition = .startRec
    }
}

extension BottomViewPresenter: BottomViewPresenterProtocol {
    func editText() {
        guard let view = view else { return }
        if let text = view.getText(), !text.isEmpty {
            actionPosition = .sendMessage
        } else {
            if actionPosition == .endRec {
                // TODO: Если была запись и мы нажали на текстФилд
            }
            actionPosition = .startRec
        }
    }
    
    func changeLang() {
        if actionPosition == .endRec {
            // TODO: Если была запись и мы нажали на смену языка
            actionPosition = .startRec
        }
        flagPosition = flagPosition.nextPosition
    }
    
    func clickAction() {
        switch actionPosition {
        case .startRec:
            actionPosition = .endRec
            view?.stopEditing()
        case .endRec:
            // TODO: Остановка записи и дальнейшая обработка
            actionPosition = .startRec
        case .sendMessage:
            actionPosition = .startRec
            view?.clearTextField()
        }
    }
    
    func getLang() -> Language {
        return flagPosition.selectedLanguage
    }
    
    func clickClear() {
        view?.clearTextField()
    }
}

extension BottomViewPresenter: BottomViewParentPresenterProtocol {
    func stopEditing() {
        if actionPosition == .endRec {
            // TODO: Если была запись и мы нажали на смену языка
            actionPosition = .startRec
        }
        view?.stopEditing()
    }
}
