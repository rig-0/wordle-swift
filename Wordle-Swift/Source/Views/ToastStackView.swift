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
        })
    }
}
