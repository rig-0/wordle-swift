//
//  HeaderView.swift
//  ©️ 2023 0100
//

import UIKit

class HeaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let labelView = UILabel()
        labelView.font = UIFont.App.wordleFont
        labelView.text = "Wordle // Swift"
        labelView.textColor = .black
        self.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        labelView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        let dividerView = UIView()
        self.addSubview(dividerView)
        dividerView.backgroundColor = UIColor.App.navBarDivider
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
