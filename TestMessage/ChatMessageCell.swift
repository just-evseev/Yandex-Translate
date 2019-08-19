import UIKit

class ChatMessageCell: UITableViewCell {

    private let translateText = UILabel()
    private let personText = UILabel()
    private let bubbleBackgroudView = UIView()
    
    private var personLeadingConstraint: NSLayoutConstraint!
    private var personTrailingConstraint: NSLayoutConstraint!
    private var translateLeadingConstraint: NSLayoutConstraint!
    private var translateTrailingConstraint: NSLayoutConstraint!
    private var bubbleTransLeadingConstraint: NSLayoutConstraint!
    private var bubbleTransTrailingConstraint: NSLayoutConstraint!
    private var bubblePersonLeadingConstraint: NSLayoutConstraint!
    private var bubblePersonTrailingConstraint: NSLayoutConstraint!
    
    private let BUBBLE_VIEW_CORNER_RADIUS: CGFloat = 16
    
    var chatMessage: ChatMessage! {
        didSet {
            bubbleBackgroudView.backgroundColor = chatMessage.isIncoming ? UIColor.blueYandex : UIColor.redYandex
            
            translateText.textColor = UIColor.whiteYandex
            translateText.text = chatMessage.transText
            
            personText.text = chatMessage.text
            personText.textColor = UIColor.grayYandex
            
            translateText.sizeToFit()
            personText.sizeToFit()
            
            if chatMessage.isIncoming {
                translateTrailingConstraint.isActive = false
                personTrailingConstraint.isActive = false
                personLeadingConstraint.isActive = true
                translateLeadingConstraint.isActive = true
                personText.textAlignment = .left
                translateText.textAlignment = .left
                bubbleBackgroudView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else {
                personLeadingConstraint.isActive = false
                translateLeadingConstraint.isActive = false
                personTrailingConstraint.isActive = true
                translateTrailingConstraint.isActive = true
                personText.textAlignment = .right
                translateText.textAlignment = .right
                bubbleBackgroudView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            }

            if (translateText.frame.width < personText.frame.width) {
                bubbleTransLeadingConstraint.isActive = false
                bubbleTransTrailingConstraint.isActive = false
                bubblePersonTrailingConstraint.isActive = true
                bubblePersonLeadingConstraint.isActive = true
            } else {
                bubblePersonTrailingConstraint.isActive = false
                bubblePersonLeadingConstraint.isActive = false
                bubbleTransLeadingConstraint.isActive = true
                bubbleTransTrailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        bubbleBackgroudView.layer.cornerRadius = BUBBLE_VIEW_CORNER_RADIUS
        bubbleBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroudView)

        personText.font = .personFont
        personText.numberOfLines = 0
        personText.sizeToFit()
        personText.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroudView.addSubview(personText)
        
        translateText.numberOfLines = 0
        translateText.font = .translatedFont
        translateText.sizeToFit()
        translateText.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroudView.addSubview(translateText)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
