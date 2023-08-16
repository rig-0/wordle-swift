//
//  ToastStackView.swift
//  ©️ 2023 0100
//

import UIKit

class ToastStackView: UIView {
  
    private var stackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.stackView = stackView
    }
    
    public func addToastItem(type: ToastItemType) {
        let toastItem = ToastItemView(type: type)
        self.stackView.addArrangedSubview(toastItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            toastItem.pop()
            print(self.stackView.arrangedSubviews.count)
        })
    }
}

enum ToastItemType: String {
    case notInWordList = "Not in word list"
    case notEnoughLetters = "Not enough letters"
}

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
