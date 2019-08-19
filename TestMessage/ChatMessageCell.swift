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
    private let BUBBLE_VIEW_EDGE_CONSTANT: CGFloat = 12
    private let BUBBLE_VIEW_INDENT_CONSTANT: CGFloat = 10
    
    var chatMessage: ChatMessage! {
        didSet {
            translateText.textColor = UIColor.whiteYandex
            translateText.text = chatMessage.transText
            translateText.textAlignment = chatMessage.isIncoming ? .left : .right
            translateText.sizeToFit()
            
            personText.text = chatMessage.text
            personText.textColor = UIColor.grayYandex
            personText.textAlignment = chatMessage.isIncoming ? .left : .right
            personText.sizeToFit()
            
            bubbleBackgroudView.backgroundColor = chatMessage.isIncoming ? .blueYandex : .redYandex
            bubbleBackgroudView.layer.maskedCorners = [chatMessage.isIncoming ? .layerMaxXMaxYCorner : .layerMinXMaxYCorner,
                                                       .layerMaxXMinYCorner, .layerMinXMinYCorner]
            bubbleBackgroudView.topAnchor.constraint(equalTo: personText.topAnchor, constant: BUBBLE_VIEW_INDENT_CONSTANT).isActive = true
            bubbleBackgroudView.bottomAnchor.constraint(equalTo: translateText.bottomAnchor, constant: BUBBLE_VIEW_INDENT_CONSTANT).isActive = true
            
            if chatMessage.isIncoming {
                bubbleBackgroudView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                personLeadingConstraint.isActive = false
                translateLeadingConstraint.isActive = false
                personTrailingConstraint.isActive = true
                translateTrailingConstraint.isActive = true
            }

            if (translateText.frame.width < personText.frame.width) {
                
            } else {
                
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = false
        transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        bubbleBackgroudView.layer.cornerRadius = BUBBLE_VIEW_CORNER_RADIUS
        bubbleBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroudView)

        personText.font = .personFont
        personText.numberOfLines = 0
        personText.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroudView.addSubview(personText)
        
        translateText.numberOfLines = 0
        translateText.font = .translatedFont
        translateText.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroudView.addSubview(translateText)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
