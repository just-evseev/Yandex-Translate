import UIKit

protocol SendElementDelegate {
    func sendElement(_ str: String, _ lang: Bool)
}

protocol BottomViewProtocol: class {
    
}

class BottomView: UIView, UITextFieldDelegate {
    
    private var changeLangButton = UIButton(type: .custom)
    private var textField = UITextField()
    private var clearTextFieldButton = UIButton(type: .custom)
    private var actionButton = UIButton(type: .custom)
    private var rusFlagImage = UIImageView(image: UIImage(named: "rusFlag"))
    private var britFlagImage = UIImageView(image: UIImage(named: "britFlag"))
    private var flagsView = UIView()
    private var actionButtonImage = UIImageView()
    
    let voiceRecogniser = VoiseRecognizer()
    var element: SendElementDelegate?
    var presenter: BottomViewPresenterProtocol?
    
    private let CORNER_RADIUS: CGFloat = 22
    private let FLAG_CORNER_RADIUS: CGFloat = 18

    private var isActiveButtonOnMicro = true
    private var isMicroActive = false
    ///
    private var isENLang = true
    /*
     true = ENG
     false = RUS
    */
    
    var rusFlagLeadingConstraint: NSLayoutConstraint!
    var britFlagTrailingConstraint: NSLayoutConstraint!
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        voiceRecogniser.voiseRecognizeTextProtocol = self
                
        backgroundColor = UIColor.blueYandex
        layer.cornerRadius = CORNER_RADIUS
        
        flagsView.backgroundColor = UIColor.whiteYandex
        flagsView.layer.cornerRadius = FLAG_CORNER_RADIUS
        
        changeLangButton.layer.cornerRadius = 18
        changeLangButton.addTarget(self, action: #selector(self.changeLanguageButtonPressed), for: .touchUpInside)
        
        textField.text = "Английский"
        textField.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)
        textField.textColor = UIColor.grayYandex
        textField.delegate = self
        textField.returnKeyType = .done
        textField.textAlignment = .natural
        textField.tintColor = UIColor.whiteYandex
        
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed), for: .touchUpInside)
        actionButtonImage.image = UIImage(named: "microphone")
        actionButtonImage.contentMode = .scaleAspectFit
        
        clearTextFieldButton.setImage(UIImage(named: "clearText"), for: .normal)
        clearTextFieldButton.addTarget(self, action: #selector(self.clearTextFieldButtonPressed), for: .touchUpInside)
        
        rusFlagImage.translatesAutoresizingMaskIntoConstraints = false
        britFlagImage.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        flagsView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        clearTextFieldButton.translatesAutoresizingMaskIntoConstraints = false
        changeLangButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        flagsView.addSubview(rusFlagImage)
        flagsView.addSubview(britFlagImage)
        flagsView.addSubview(changeLangButton)
        addSubview(textField)
        addSubview(actionButtonImage)
        addSubview(actionButton)
        addSubview(clearTextFieldButton)
        addSubview(flagsView)
        
        let constraints = [
            flagsView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            flagsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            flagsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            flagsView.widthAnchor.constraint(equalToConstant: 46),
            
            rusFlagImage.topAnchor.constraint(equalTo: flagsView.topAnchor, constant: 2),
            rusFlagImage.bottomAnchor.constraint(equalTo: flagsView.bottomAnchor, constant: -2),
            rusFlagImage.widthAnchor.constraint(equalToConstant: 32),
            
            britFlagImage.topAnchor.constraint(equalTo: flagsView.topAnchor, constant: 2),
            britFlagImage.bottomAnchor.constraint(equalTo: flagsView.bottomAnchor, constant: -2),
            britFlagImage.widthAnchor.constraint(equalToConstant: 32),
            
            actionButtonImage.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            actionButtonImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            actionButtonImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            actionButtonImage.widthAnchor.constraint(equalToConstant: 18),
            
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            actionButton.widthAnchor.constraint(equalToConstant: 28),
            
            clearTextFieldButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            clearTextFieldButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: actionButtonImage.leadingAnchor, constant: -10),
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: 16),
            
            textField.leadingAnchor.constraint(equalTo: flagsView.trailingAnchor, constant: 6),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            textField.trailingAnchor.constraint(equalTo: clearTextFieldButton.leadingAnchor, constant: 5),
            
            changeLangButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            changeLangButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            changeLangButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            changeLangButton.widthAnchor.constraint(equalToConstant: 46)
        ]
        NSLayoutConstraint.activate(constraints)
        
        rusFlagLeadingConstraint = rusFlagImage.leadingAnchor.constraint(equalTo: flagsView.leadingAnchor, constant: 2)
        rusFlagLeadingConstraint.isActive = true
        britFlagTrailingConstraint = britFlagImage.trailingAnchor.constraint(equalTo: flagsView.trailingAnchor, constant: -2)
        britFlagTrailingConstraint.isActive = true
    }
    
    @objc func actionButtonPressed(sender: UIButton) {
        if isActiveButtonOnMicro {
            if !isMicroActive {
                actionButtonImage.image = UIImage(named: "startVoice")
                isMicroActive = true
                voiceRecogniser.voiceRecognizeStart(lang: isENLang)
            } else {
                actionButtonImage.image = UIImage(named: "microphone")
                isMicroActive = false
                voiceRecogniser.voiceRecognizeStop()
            }
        } else {
            endEditing(true)
            let str = textField.text!
            if (str != "" && str != "Русский" && str != "Английский") {
                element?.sendElement(textField.text!, isENLang)
                textField.text = isENLang ? "Английский" : "Русский"
            } else if (str == "") {
                textField.text = isENLang ? "Английский" : "Русский"
            }
            actionButtonImage.image = UIImage(named: "microphone")
            isActiveButtonOnMicro = true
            if isMicroActive {
                voiceRecogniser.voiceRecognizeStop()
                isMicroActive = false
            }
        }
    }
    
    @objc func changeLanguageButtonPressed(sender: UIButton) {
        changeLanguage()
    }
    
    @objc func clearTextFieldButtonPressed(sender: UIButton) {
        if textField.isEditing {
            self.textField.text = ""
        } else if isENLang {
            self.textField.text = "Английский"
        } else {
            self.textField.text = "Русский"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textField.text = ""
        self.textField.textColor = UIColor.whiteYandex
        actionButtonImage.image = UIImage(named: "sendMsg")
        isActiveButtonOnMicro = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.textColor = UIColor.grayYandex
    }
    
    func changeLanguage() {
        isENLang = !isENLang
        if (rusFlagLeadingConstraint.constant != 2) {
            rusFlagLeadingConstraint.constant = 2
            britFlagTrailingConstraint.constant = -2
            UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
                if (!self.textField.isEditing) {
                    if (self.textField.text == "") {
                        self.textField.text = "Английский"
                    } else if (self.textField.text == "Русский") {
                        self.textField.text = "Английский"
                    }
                }
                self.flagsView.sendSubviewToBack(self.rusFlagImage)
                self.layoutIfNeeded()
                self.backgroundColor = UIColor.blueYandex
            }.startAnimation()
        } else {
            rusFlagLeadingConstraint.constant = 12
            britFlagTrailingConstraint.constant = -12
            UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
                if (!self.textField.isEditing) {
                    if (self.textField.text == "") {
                        self.textField.text = "Русский"
                    } else if (self.textField.text == "Английский") {
                        self.textField.text = "Русский"
                    }
                }
                self.flagsView.sendSubviewToBack(self.britFlagImage)
                self.layoutIfNeeded()
                self.backgroundColor = UIColor.redYandex
            }.startAnimation()
        }
    }
    
    func displayToches() {
        endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomView: VoiceRecognizeText {
    func getText(text: String) {
        element?.sendElement(text, isENLang)
    }
}

extension BottomView: BottomViewProtocol {
    
}
