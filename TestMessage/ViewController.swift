import UIKit

struct ChatMessage {
    let text: String
    let transText: String
    let isIncoming: Bool
}

class ViewController: UIViewController, UITableViewDelegate, SendElementDelegate, TextSender, AlertProtocol {
    
    private let cellId = "i\\d"
    private let tableView = UITableView()
    private var bottomView = BottomView()
    private var bottomBottomViewConstraint: NSLayoutConstraint!
    var chatMessages = [ChatMessage]()
    let YC = YandexClient()
    
    private let INDENT_DISTANCE: CGFloat = -16
    private let BOTTOM_VIEW_HEIGHT: CGFloat = 44
    private let YANDEX_LOGO_HEIGHT: CGFloat = 20.9
    private let YABDEX_LOGO_TOP_CONSTANT: CGFloat = 18
    private let BOTTOM_VIEW_EDGE_INDENT: CGFloat = 4
    private let YANDEX_LOGO_MULTIPLIER: CGFloat = 6.83
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YC.textProtocol = self
        
        bottomView.element = self
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.heightAnchor.constraint(equalToConstant: BOTTOM_VIEW_HEIGHT).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: BOTTOM_VIEW_EDGE_INDENT).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -BOTTOM_VIEW_EDGE_INDENT).isActive = true
        bottomBottomViewConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: INDENT_DISTANCE)
        bottomBottomViewConstraint.isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: -(.pi));
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: INDENT_DISTANCE).isActive = true
        
        let imageView = UIImageView()
        let yandexLogo = UIImage(named: "yandexLogo")
        imageView.image = yandexLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: YABDEX_LOGO_TOP_CONSTANT).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: YANDEX_LOGO_HEIGHT).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: YANDEX_LOGO_MULTIPLIER).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    func sendElement(_ str: String, _ lang: Bool) {
        YC.getLang(text: str, lang: lang)
    }
    
    func sendTextLang(text: String, lang: String) {
        YC.getMethod(textToTranslate: text, lang: lang)
    }
    
    func sendTranslatedText(text: String, translatedText: String, lang: String) {
        chatMessages.insert(ChatMessage(text: text, transText: translatedText, isIncoming: lang == "en"), at: 0)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(n: NSNotification) {
        if let keyboardHeight = (n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            bottomBottomViewConstraint.constant = -keyboardHeight + INDENT_DISTANCE
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(n: NSNotification) {
        bottomBottomViewConstraint.constant = INDENT_DISTANCE
        view.layoutIfNeeded()
    }

    @objc func handleTap() {
        bottomView.displayToches()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let chatMessage = chatMessages[indexPath.row]
        
        cell.chatMessage = chatMessage
        cell.isUserInteractionEnabled = false
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
        
        return cell
    }
}
