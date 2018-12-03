import UIKit

class ChatMessageCell: UITableViewCell {

    let translateText = UILabel()
    let personText = UILabel()
    let bubbleBackgroudView = UIView()
    
    var personLeadingConstraint: NSLayoutConstraint!
    var personTrailingConstraint: NSLayoutConstraint!
    var translateLeadingConstraint: NSLayoutConstraint!
    var translateTrailingConstraint: NSLayoutConstraint!
    var bubbleTransLeadingConstraint: NSLayoutConstraint!
    var bubbleTransTrailingConstraint: NSLayoutConstraint!
    var bubblePersonLeadingConstraint: NSLayoutConstraint!
    var bubblePersonTrailingConstraint: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            bubbleBackgroudView.backgroundColor = chatMessage.isIncoming ? UIColor.blueYandex : UIColor.redYandex
            
            translateText.textColor = UIColor.whiteYandex
            translateText.text = chatMessage.transText
            
            personText.text = chatMessage.text
            personText.textColor = UIColor.grayYandex
            
            if chatMessage.isIncoming {
                personLeadingConstraint.isActive = true
                personTrailingConstraint.isActive = false
                translateLeadingConstraint.isActive = true
                translateTrailingConstraint.isActive = false
                personText.textAlignment = .left
                translateText.textAlignment = .left
                bubbleBackgroudView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else {
                personTrailingConstraint.isActive = true
                personLeadingConstraint.isActive = false
                translateTrailingConstraint.isActive = true
                translateLeadingConstraint.isActive = false
                personText.textAlignment = .right
                translateText.textAlignment = .right
                bubbleBackgroudView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            
            translateText.sizeToFit()
            personText.sizeToFit()
            
            if (translateText.frame.width < personText.frame.width) {
                bubbleTransLeadingConstraint.isActive = false
                bubbleTransTrailingConstraint.isActive = false
                bubblePersonTrailingConstraint.isActive = true
                bubblePersonLeadingConstraint.isActive = true
            } else {
                bubbleTransLeadingConstraint.isActive = true
                bubbleTransTrailingConstraint.isActive = true
                bubblePersonTrailingConstraint.isActive = false
                bubblePersonLeadingConstraint.isActive = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        bubbleBackgroudView.layer.cornerRadius = 16
        
        personText.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        translateText.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)
        translateText.sizeToFit()
        personText.sizeToFit()
        
        bubbleBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        personText.translatesAutoresizingMaskIntoConstraints = false
        translateText.translatesAutoresizingMaskIntoConstraints = false
        
        personText.numberOfLines = 0
        translateText.numberOfLines = 0
        
        addSubview(bubbleBackgroudView)
        addSubview(personText)
        addSubview(translateText)
        
        let constraints = [
            personText.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            personText.widthAnchor.constraint(lessThanOrEqualToConstant: 199),
            
            translateText.topAnchor.constraint(equalTo: personText.bottomAnchor, constant: 2),
            translateText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            translateText.widthAnchor.constraint(lessThanOrEqualToConstant: 199),
            
            bubbleBackgroudView.topAnchor.constraint(equalTo: personText.topAnchor, constant: -11),
            bubbleBackgroudView.bottomAnchor.constraint(equalTo: translateText.bottomAnchor, constant: 11)
        ]
        NSLayoutConstraint.activate(constraints)
        
        
        personLeadingConstraint = translateText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        translateLeadingConstraint = personText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        
        personTrailingConstraint = translateText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        translateTrailingConstraint = personText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        
        bubbleTransLeadingConstraint = bubbleBackgroudView.leadingAnchor.constraint(equalTo: translateText.leadingAnchor, constant: -12)
        bubbleTransTrailingConstraint = bubbleBackgroudView.trailingAnchor.constraint(equalTo: translateText.trailingAnchor, constant: 12)
        bubblePersonLeadingConstraint = bubbleBackgroudView.leadingAnchor.constraint(equalTo: personText.leadingAnchor, constant: -12)
        bubblePersonTrailingConstraint = bubbleBackgroudView.trailingAnchor.constraint(equalTo: personText.trailingAnchor, constant: 12)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
