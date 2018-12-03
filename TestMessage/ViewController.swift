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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendElementDelegate, TextSender {
    
    let cellId = "id"
    private var tableView: UITableView!

    var chatMessages = [ChatMessage]()
    
    let YC = YandexClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let customView = UIView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: 72 - barHeight))
        let yandexLogo = UIImage(named: "yandexLogo")
        let yandexlogoImageView = UIImageView(frame: CGRect(x: displayWidth / 2 - 71.41, y: (72 - barHeight) / 2 - 10.45, width: 142.82, height: 20.9))
        yandexlogoImageView.image = yandexLogo
        customView.addSubview(yandexlogoImageView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 72, width: displayWidth, height: displayHeight - 159))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi));
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)
        
        let buttomView = ButtomView(frame: CGRect(x: 4, y: displayHeight - 60, width: displayWidth - 8, height: 44))
        buttomView.element = self
        
        view.addSubview(tableView)
        view.addSubview(buttomView)
        view.addSubview(customView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        YC.textProtocol = self
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}
