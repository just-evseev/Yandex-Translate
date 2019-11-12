import UIKit

protocol BottomViewProtocol: class {
    ///Остановить редактирование
    func stopEditing()
    ///Очистить пол ввода
    func clearTextField()
    ///Изменить язык
    /// - Parameter with: Позиция на которую меняем язык
    func changeLang(with position: FlagsPosition)
    func changeActionButton(with state: ActionButtonPosition)
    /// - Returns: Текст введенный в поле ввода (если поле ввода пустое, то вернет nil)
    func getText() -> String?
}

class BottomView: UIView {
    //Поле ввода текста для перевода
    private let textField = UITextField()
    //Кнопка удаления
    private let clearTextFieldButton = UIButton()
    //Кнопка действия (запись аудио/остановить запись/отправить текст на перевод)
    private let actionButton = UIButton()
    ///View для русского флага
    private let rusFlagImage = UIImageView()
    ///View для английского флага
    private let britFlagImage = UIImageView()
    ///View с флагами
    private let flagsView = UIView()
    ///Кнопка для обнарежения нажатия на View с флагами
    private let flagsButton = UIButton()
    //Constraints для работы с анимацией перемещения флагов при нажатии
    private var rusFlagLeadingConstraint: NSLayoutConstraint!
    private var britFlagTrailingConstraint: NSLayoutConstraint!
    
    ///Презентер для нашей вьюхи
    var presenter: BottomViewPresenterProtocol?
    
    //Константы
    private let VIEW_HEIGHT: CGFloat = 44
    private let FLAG_VIEW_HEIGHT: CGFloat = 36
    private let FLAG_VIEW_WIDTH: CGFloat = 46
    private let FLAG_CORNER_RADIUS: CGFloat = 18
    private let LANG_FLAG_SIZE: CGFloat = 32
    private let LANG_FLAG_BORDER_WIDTH: CGFloat = 2
    private let CLEAR_BUTTON_SIZE: CGFloat = 16
    private let CLEAR_AND_ACTION_DISTANCE: CGFloat = 10
    private let CLEAR_TOP: CGFloat = 14
    private let EDGE_LANG_FLAG_CONSTANT: CGFloat = 2
    private let EDGE_FLAG_VIEW_CONSTANT: CGFloat = 4
    private let TOP_BOTTOM_TEXT_FIELD_CONSTANT: CGFloat = 12
    private let LEAD_TRAIL_TEXT_FIELD_CONSTANT: CGFloat = 6
    private let ACTION_BUTTON_WIDTH: CGFloat = 28
    private let DIFFERENCE_FLAG_CHANGED: CGFloat = 10
    private let ACTION_BTN_TOP: CGFloat = 14
    private let ACTION_BTN_TRAIL: CGFloat = -16
    private let ACTION_BTN_WIDTH: CGFloat = 12
    private let ACTION_BTN_HEIGHT: CGFloat = 16
    
    private let CHANGE_LANG_DURATION = 0.3
    
    init () {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.blueYandex
        layer.cornerRadius = VIEW_HEIGHT / 2
        
        flagsView.backgroundColor = UIColor.whiteYandex
        flagsView.layer.cornerRadius = FLAG_VIEW_HEIGHT / 2
        flagsView.translatesAutoresizingMaskIntoConstraints = false
        flagsView.addSubview(rusFlagImage)
        flagsView.addSubview(britFlagImage)
        addSubview(flagsView)
        flagsView.topAnchor.constraint(equalTo: topAnchor, constant: EDGE_FLAG_VIEW_CONSTANT).isActive = true
        flagsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: EDGE_FLAG_VIEW_CONSTANT).isActive = true
        flagsView.heightAnchor.constraint(equalToConstant: FLAG_VIEW_HEIGHT).isActive = true
        flagsView.widthAnchor.constraint(equalToConstant: FLAG_VIEW_WIDTH).isActive = true
        
        flagsButton.setTitle(nil, for: .normal)
        flagsButton.backgroundColor = .clear
        flagsButton.addTarget(self, action: #selector(flagsPressed), for: .touchUpInside)
        flagsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flagsButton)
        flagsButton.topAnchor.constraint(equalTo: flagsView.topAnchor).isActive = true
        flagsButton.leadingAnchor.constraint(equalTo: flagsView.leadingAnchor).isActive = true
        flagsButton.trailingAnchor.constraint(equalTo: flagsView.trailingAnchor).isActive = true
        flagsButton.bottomAnchor.constraint(equalTo: flagsView.bottomAnchor).isActive = true
        
        rusFlagImage.image = Language.rus.image
        rusFlagImage.layer.borderColor = UIColor.whiteYandex.cgColor
        rusFlagImage.layer.borderWidth = LANG_FLAG_BORDER_WIDTH
        rusFlagImage.layer.cornerRadius = LANG_FLAG_SIZE / 2
        rusFlagImage.translatesAutoresizingMaskIntoConstraints = false
        rusFlagImage.topAnchor.constraint(equalTo: flagsButton.topAnchor, constant: EDGE_LANG_FLAG_CONSTANT).isActive = true
        rusFlagImage.widthAnchor.constraint(equalToConstant: LANG_FLAG_SIZE).isActive = true
        rusFlagImage.heightAnchor.constraint(equalTo: rusFlagImage.widthAnchor).isActive = true
        
        britFlagImage.image = Language.eng.image
        britFlagImage.layer.borderColor = UIColor.whiteYandex.cgColor
        britFlagImage.layer.borderWidth = LANG_FLAG_BORDER_WIDTH
        britFlagImage.layer.cornerRadius = LANG_FLAG_SIZE / 2
        britFlagImage.translatesAutoresizingMaskIntoConstraints = false
        britFlagImage.topAnchor.constraint(equalTo: flagsButton.topAnchor, constant: EDGE_LANG_FLAG_CONSTANT).isActive = true
        britFlagImage.widthAnchor.constraint(equalToConstant: LANG_FLAG_SIZE).isActive = true
        britFlagImage.heightAnchor.constraint(equalTo: britFlagImage.widthAnchor).isActive = true
        
        actionButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
        actionButton.imageView?.contentMode = .scaleToFill
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        actionButton.topAnchor.constraint(equalTo: topAnchor, constant: ACTION_BTN_TOP).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ACTION_BTN_TRAIL).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: ACTION_BTN_WIDTH).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: ACTION_BTN_HEIGHT).isActive = true
        
        clearTextFieldButton.setImage(.clearImage, for: .normal)
        clearTextFieldButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        clearTextFieldButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(clearTextFieldButton)
        clearTextFieldButton.topAnchor.constraint(equalTo: topAnchor, constant: CLEAR_TOP).isActive = true
        clearTextFieldButton.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -CLEAR_AND_ACTION_DISTANCE).isActive = true
        clearTextFieldButton.widthAnchor.constraint(equalToConstant: CLEAR_BUTTON_SIZE).isActive = true
        clearTextFieldButton.heightAnchor.constraint(equalTo: clearTextFieldButton.widthAnchor).isActive = true
        
        textField.attributedPlaceholder = FlagsPosition.engFirst.placeholderText
        textField.textColor = .whiteYandex
        textField.font = UIFont.textFieldFont
        textField.delegate = self
        textField.tintColor = UIColor.whiteYandex
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: flagsButton.trailingAnchor, constant: LEAD_TRAIL_TEXT_FIELD_CONSTANT).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: TOP_BOTTOM_TEXT_FIELD_CONSTANT).isActive = true
        textField.trailingAnchor.constraint(equalTo: clearTextFieldButton.leadingAnchor, constant: -LEAD_TRAIL_TEXT_FIELD_CONSTANT).isActive = true
        
        rusFlagLeadingConstraint = rusFlagImage.leadingAnchor.constraint(equalTo: flagsButton.leadingAnchor, constant: EDGE_LANG_FLAG_CONSTANT)
        rusFlagLeadingConstraint.isActive = true
        britFlagTrailingConstraint = britFlagImage.trailingAnchor.constraint(equalTo: flagsButton.trailingAnchor, constant: -EDGE_LANG_FLAG_CONSTANT)
        britFlagTrailingConstraint.isActive = true
    }
    
    @objc func clearPressed() {
        presenter?.clickClear()
    }
    
    @objc func flagsPressed() {
        presenter?.changeLang()
    }
    
    @objc func actionPressed() {
        presenter?.clickAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomView: BottomViewProtocol {
    func changeActionButton(with state: ActionButtonPosition) {
        actionButton.setImage(state.image, for: .normal)
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func stopEditing() {
        textField.resignFirstResponder()
    }
    
    func clearTextField() {
        textField.text = nil
    }
    
    func changeLang(with position: FlagsPosition) {
        rusFlagLeadingConstraint.constant = position.constraintConstant
        britFlagTrailingConstraint.constant = -position.constraintConstant
        UIViewPropertyAnimator(duration: CHANGE_LANG_DURATION, curve: .easeIn) {
            self.textField.attributedPlaceholder = position.placeholderText
            self.backgroundColor = position.backgroundColor
            if position == .engFirst {
                self.flagsView.sendSubviewToBack(self.rusFlagImage)
            } else {
                self.flagsView.sendSubviewToBack(self.britFlagImage)
            }
            self.layoutIfNeeded()
        }.startAnimation()
    }
}

extension BottomView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        presenter?.editText()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presenter?.editText()
        return true
    }
}
