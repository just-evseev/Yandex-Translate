import UIKit

extension UIColor {
    static let blueYandex = UIColor(red: 0/255, green: 124/255, blue: 233/255, alpha: 1.0)
    static let redYandex = UIColor(red: 237/255, green: 76/255, blue: 92/255, alpha: 1.0)
    static let whiteYandex = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    static let grayYandex = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 0.8)
}

struct ChatMessage {
    let text: String
    let transText: String
    let isIncoming: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendElementDelegate, TextSender, AlertProtocol {
    
    private let cellId = "id"
    private var tableView: UITableView!
    private var customView: UIView!
    private var yandexlogoImageView: UIImageView!
    private var bottomView: ButtomView!

    var chatMessages = [ChatMessage]()
    
    private var barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    private var displayWidth = CGFloat()
    private var displayHeight = CGFloat()
    private var isPortrait = true
    
    let YC = YandexClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YC.textProtocol = self
        
        displayWidth = view.frame.width
        displayHeight = view.frame.height
        
        customView = UIView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: 72 - barHeight))
        let yandexLogo = UIImage(named: "yandexLogo")
        yandexlogoImageView = UIImageView(frame: CGRect(x: displayWidth / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9))
        yandexlogoImageView.image = yandexLogo
        customView.addSubview(yandexlogoImageView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 72, width: displayWidth, height: displayHeight - 159))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi));
        tableView.showsVerticalScrollIndicator = false
        
        bottomView = ButtomView(frame: CGRect(x: 4, y: displayHeight - 60, width: displayWidth - 8, height: 44))
        bottomView.element = self
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(customView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
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
    
    func sendElement(_ str: String, _ lang: Bool) {
        YC.getLang(text: str, lang: lang)
    }
    
    func sendTextLang(text: String, lang: String) {
        YC.getMethod(textToTranslate: text, lang: lang)
    }
    
    func sendTranslatedText(text: String, translatedText: String, lang: String) {
        var langBool: Bool
        if (lang == "en") {
            langBool = true
        } else {
            langBool = false
        }
        chatMessages.insert(ChatMessage(text: text, transText: translatedText, isIncoming: langBool), at: 0)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.fade)
                // как я понимаю анимация добавления новой ячейки кастомная, не получилось подобрать из стандартных
            self.tableView.endUpdates()
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            bottomView.frame.origin.y -= keyboardHeight
            tableView.frame.size.height -= keyboardHeight - 22
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isPortrait {
            bottomView.frame = CGRect(x: 4, y: displayHeight - 60, width: displayWidth - 8, height: 44)
            tableView.frame = CGRect(x: 0, y: 72, width: displayWidth, height: displayHeight - 159)
        } else {
            tableView.frame = CGRect(x: 0, y: 72, width: displayHeight, height: (displayWidth - 159))
            bottomView.frame = CGRect(x: 4, y: displayWidth - 60, width: displayHeight - 8, height: 44)
        }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation{
        case .portrait:
            isPortrait = true
            customView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: 72 - barHeight)
            yandexlogoImageView.frame = CGRect(x: displayWidth / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9)
            tableView.frame = CGRect(x: 0, y: 72, width: displayWidth, height: (displayHeight - 159))
            bottomView.frame = CGRect(x: 4, y: displayHeight - 60, width: displayWidth - 8, height: 44)
        case .portraitUpsideDown:
            isPortrait = true
            customView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: 72 - barHeight)
            yandexlogoImageView.frame = CGRect(x: displayWidth / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9)
            tableView.frame = CGRect(x: 0, y: 72, width: displayWidth, height: (displayHeight - 159))
            bottomView.frame = CGRect(x: 4, y: displayHeight - 60, width: displayWidth - 8, height: 44)
        case .landscapeLeft:
            isPortrait = false
            customView.frame = CGRect(x: 0, y: barHeight, width: displayHeight, height: 72 - barHeight)
            yandexlogoImageView.frame = CGRect(x: displayHeight / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9)
            tableView.frame = CGRect(x: 0, y: 72, width: displayHeight, height: (displayWidth - 159))
            bottomView.frame = CGRect(x: 4, y: displayWidth - 60, width: displayHeight - 8, height: 44)
        case .landscapeRight:
            isPortrait = false
            customView.frame = CGRect(x: 0, y: barHeight, width: displayHeight, height: 72 - barHeight)
            yandexlogoImageView.frame = CGRect(x: displayHeight / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9)
            tableView.frame = CGRect(x: 0, y: 72, width: displayHeight, height: (displayWidth - 159))
            bottomView.frame = CGRect(x: 4, y: displayWidth - 60, width: displayHeight - 8, height: 44)
        default:
            print("Error in orientation")
        }
    }

    @objc func handleTap() {
        bottomView.displayToches()
    }
}
