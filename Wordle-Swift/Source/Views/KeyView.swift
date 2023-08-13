//
//  KeyView.swift
//  ©️ 2023 0100
//

import UIKit

class KeyView: UIView {

    private var key: Key?
    private var labelView: UILabel!
    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    init(key: Key? = nil) {
        self.key = key
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 50)
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 50)
        self.widthConstraint.isActive = true
        self.heightConstraint.isActive = true
        
        self.backgroundColor = UIColor.App.keyStateEmpty
        self.layer.cornerRadius = 3
        
        let labelView = UILabel()
        labelView.textColor = .black
        labelView.font = UIFont.App.keyStandardFont
        labelView.textAlignment = .center
        self.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.labelView = labelView
        
        update()
    }
    
    private func update() {
        self.labelView.attributedText = self.textForKey(self.key)
        self.backgroundColor = self.backgroundColorForKey(self.key)
    }
    
    private func textForKey(_ : Key?) -> NSAttributedString? {
        switch self.key {
        case .__:
            return nil
        case .ENTER:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.App.keyEnterFont ]
            return NSAttributedString(string: "ENTER", attributes: myAttribute)
        case .DELETE:
            let attachment = NSTextAttachment()
            let deleteImage = UIImage(named: "Key_DELETE")!
            attachment.image = deleteImage
            attachment.bounds = CGRect(x: 0, y: -2, width: deleteImage.size.width, height: deleteImage.size.height)
            return NSAttributedString(attachment: attachment)
        default:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.App.keyStandardFont ]
            return NSAttributedString(string: self.key?.rawValue ?? "", attributes: myAttribute)
        }
    }
    
    private func backgroundColorForKey(_ : Key?) -> UIColor {
        switch self.key {
        case .__:
            return .clear
        default:
            return UIColor.App.keyStateEmpty
        }
    }
    
    public func updateKeySizeWithStandardWidth(_ width: CGFloat) {
        switch self.key {
        case .__:
            self.widthConstraint.constant = width * 0.35
            self.heightConstraint.constant = width * 1.4
        case .ENTER, .DELETE:
            self.widthConstraint.constant = width * 1.5
            self.heightConstraint.constant = width * 1.4
        default:
            self.widthConstraint.constant = width
            self.heightConstraint.constant = width * 1.4
        }
    }
}
