//
//  ToastItemView.swift
//  ©️ 2023 0100
//

import UIKit

class ToastItemView: UIView {
    
    var type: ToastItemType
    
    init(type: ToastItemType) {
        self.type = type
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 3
        
        let errorLabel = UILabel()
        self.addSubview(errorLabel)
        errorLabel.font = UIFont.App.toastFont
        errorLabel.text = type.rawValue
        errorLabel.textColor = .white
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    public func pop() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.isHidden = true
            }, completion: { finished in
                self.removeFromSuperview()
            })
        })
    }
}
