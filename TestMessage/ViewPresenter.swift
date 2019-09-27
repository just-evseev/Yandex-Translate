//
//  ViewPresenter.swift
//  TestMessage
//
//  Created by Ilya on 19/08/2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit

protocol ViewPresenterProtocol: class {
    func getRowCount() -> Int
    func getMessage(for index: Int) -> ChatMessage
    func getBottomViewPresenter(for view: BottomViewProtocol) -> BottomViewPresenterProtocol
    func tapOnView()
}

class ViewPresenter {
    weak var view: ViewControllerProtocol?
    private weak var bottomViewPresenter: BottomViewParentPresenterProtocol?
    private var chatMessages = [ChatMessage]()
    private let YC = YandexClient()
    init() {        
        YC.textProtocol = self
    }
}

extension ViewPresenter: ViewPresenterProtocol {
    func getRowCount() -> Int {
        return chatMessages.count
    }
    
    func getMessage(for index: Int) -> ChatMessage {
        return chatMessages[index]
    }
    
    func getBottomViewPresenter(for view: BottomViewProtocol) -> BottomViewPresenterProtocol {
        let presenter = BottomViewPresenter()
        presenter.view = view
        bottomViewPresenter = presenter
        return presenter
    }
    
    func tapOnView() {
        bottomViewPresenter?.stopEditing()
    }
}

extension ViewPresenter: YandexClientTextSender {
    func sendTranslatedText(text: String, translatedText: String, lang: String) {
    }
    
    func sendTextLang(text: String, lang: String) {
    }
}

extension ViewPresenter: AlertProtocol {
    func sendAlert(message: String) {
    }
}

//extension ViewPresenter: SendElementDelegate {
//    func sendElement(_ str: String, _ lang: Bool) {
//    }
//}

//    func sendElement(_ str: String, _ lang: Bool) {
//        YC.getLang(text: str, lang: lang)
//    }
//
//    func sendTextLang(text: String, lang: String) {
//        YC.getMethod(textToTranslate: text, lang: lang)
//    }
//
//    func sendTranslatedText(text: String, translatedText: String, lang: String) {
//        chatMessages.insert(ChatMessage(text: text, transText: translatedText, isIncoming: lang == "en"), at: 0)
//        DispatchQueue.main.async {
//            self.tableView.beginUpdates()
//            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.fade)
//            self.tableView.endUpdates()
//        }
//    }

//    func sendAlert(message: String) {
//        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
