import UIKit

protocol ViewControllerProtocol: class {
    
}

class ViewController: UIViewController {
    
    private let cellId = "i\\d"
    private let tableView = UITableView()
    private var bottomView = BottomView()
    private var bottomBottomViewConstraint: NSLayoutConstraint!
    private var presenter: ViewPresenterProtocol!
    
    private let INDENT_DISTANCE: CGFloat = -16
    private let BOTTOM_VIEW_HEIGHT: CGFloat = 44
    private let YANDEX_LOGO_HEIGHT: CGFloat = 20.9
    private let YABDEX_LOGO_TOP_CONSTANT: CGFloat = 18
    private let BOTTOM_VIEW_EDGE_INDENT: CGFloat = 4
    private let YANDEX_LOGO_MULTIPLIER: CGFloat = 6.83
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = ViewPresenter()
        presenter.view = self
        self.presenter = presenter
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.heightAnchor.constraint(equalToConstant: BOTTOM_VIEW_HEIGHT).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: BOTTOM_VIEW_EDGE_INDENT).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -BOTTOM_VIEW_EDGE_INDENT).isActive = true
        bottomBottomViewConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: INDENT_DISTANCE)
        bottomBottomViewConstraint.isActive = true
        
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
        return presenter.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatMessage = presenter.getMessage(for: indexPath.row)
        return cell
    }
}

extension ViewController: ViewControllerProtocol {
    
}
