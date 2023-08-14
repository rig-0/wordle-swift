//
//  TileView.swift
//  ©️ 2023 0100
//

import UIKit

class TileView: UIView {

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
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true

        self.layer.borderColor = UIColor.App.keyStateEmpty.cgColor
        self.layer.borderWidth = 2
        
        let labelView = UILabel()
        labelView.textColor = .black
        labelView.font = UIFont.App.tileFont
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
        if let key = self.key {
            self.layer.borderColor = UIColor.App.keyStateTbd.cgColor
        } else {
            self.layer.borderColor = UIColor.App.keyStateEmpty.cgColor
        }
    }
}

