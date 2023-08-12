//
//  TileView.swift
//  ©️ 2023 0100
//

import UIKit

class TileView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
    }
    
}

