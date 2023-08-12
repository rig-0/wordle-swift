//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

class GridView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        // Primary grid view that contains all tiles
        let gridView = UIStackView()
        gridView.axis = .vertical
        gridView.spacing = 5
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // Number of attempts
        for _ in 0 ..< 5 {
            
            let tileRow = UIStackView()
            tileRow.axis = .horizontal
            tileRow.spacing = 5
            gridView.addArrangedSubview(tileRow)
            
            // Number of characters per attempt
            for _ in 0 ..< 5 {
                let tile = TileView()
                tileRow.addArrangedSubview(tile)
            }
        }
    }
    
}
