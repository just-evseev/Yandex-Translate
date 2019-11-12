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
    private lazy var YC: YandexClient = {
        return YandexClient(textProtocol: self)
    }()
    
    init(view: ViewControllerProtocol) {
        self.view = view
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
    func sendTranslatedText(text: String, translatedText: String, lang: Language) {
    }
    
    func sendTextLang(text: String, lang: Language) {
    }
}

extension ViewPresenter: AlertProtocol {
    func sendAlert(message: String) {
    }
}
