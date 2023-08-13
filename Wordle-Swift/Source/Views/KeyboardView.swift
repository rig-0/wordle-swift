//
//  KeyboardView.swift
//  ©️ 2023 0100
//

import UIKit

class KeyboardView: UIView {
    
    let rows: [[Key]] =
    [
        [.Q, .W, .E, .R, .T, .Y, .U, .I, .O, .P ],
        [.__, .A, .S, .D, .F, .G, .H, .J, .K, .L, .__],
        [.ENTER, .Z, .X, .C, .V, .B, .N, .M, .DELETE]
    ]
        
    let kSpacingBetweenKeys = 5
    
    var keyViews: [KeyView] = []
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Determine standard key size, assume first row is all standard characters
        let keysPerRow = rows.first?.count ?? 0
        let availableWidth: CGFloat = self.frame.width
        let widthWithouthSpacing = availableWidth - CGFloat(kSpacingBetweenKeys * (keysPerRow - 1))
        let standardKeyWidth = widthWithouthSpacing / CGFloat(keysPerRow)
        self.keyViews.forEach { $0.updateKeySizeWithStandardWidth(standardKeyWidth) }
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
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.spacing = CGFloat(self.kSpacingBetweenKeys)
            gridView.addArrangedSubview(rowView)

            // Add KeyView for each key in row
            for key in self.rows[i] {
                let keyView = KeyView(key: key)
                rowView.addArrangedSubview(keyView)
                keyViews.append(keyView)
            }
        }
    }
    
}
