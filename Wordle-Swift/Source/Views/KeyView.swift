//
//  KeyView.swift
//  ©️ 2023 0100
//

import UIKit

class KeyView: UIView {

    var key: Key? {
        didSet {
            self.update()
        }
    }
    
    private var labelView: UILabel!
    
    init(key: Key? = nil) {
        super.init(frame: .zero)
        self.key = key
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.4).isActive = true

        self.backgroundColor = UIColor.App.keyStateEmpty
        self.layer.cornerRadius = 3
        
        let labelView = UILabel()
        labelView.textColor = .black
        labelView.font = UIFont.App.keyFont
        labelView.textAlignment = .center
        self.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.labelView = labelView
        
        update()
    }
    
    private func update() {
        self.labelView.text = self.key?.rawValue
    }
}
