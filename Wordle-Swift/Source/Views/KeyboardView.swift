//
//  KeyboardView.swift
//  ©️ 2023 0100
//

import UIKit

class KeyboardView: UIView {
    
    let rows: [[Key]] =
    [
        [.Q, .W, .E, .R, .T, .Y, .U, .I, .O, .P ],
        [.A, .S, .D, .F, .G, .H, .J, .K, .L],
        [.ENTER, .Z, .X, .C, .V, .B, .N, .M, .DELETE]
    ]
    
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
        
        // Number of rows
        for i in 0 ..< self.rows.count {

            let tileRow = UIStackView()
            tileRow.axis = .horizontal
            tileRow.spacing = 3
            gridView.addArrangedSubview(tileRow)

            // Add KeyView for each key in row
            for key in self.rows[i] {
                let tile = KeyView(key: key)
                tileRow.addArrangedSubview(tile)
            }
        }
    }
    
}
