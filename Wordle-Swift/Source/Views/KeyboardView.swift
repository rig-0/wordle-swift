//
//  KeyboardView.swift
//  ©️ 2023 0100
//

import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func didSelect(key: Key)
}

class KeyboardView: UIView {
    
    public weak var delegate: KeyboardViewDelegate?
    
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
                keyView.delegate = self
                rowView.addArrangedSubview(keyView)
                keyViews.append(keyView)
            }
        }
    }
    
    public func updateKeyStates(tileViews: [[TileView]]) {
        let correctWord = "AAAZZ"
        
        var keyStates: [Key : KeyState] = [:]
        for key in Key.allCases {
            // For each key that is not ENTER or DELETE, determine state
            // of key by checking against correct word
            if key == .ENTER || key == .DELETE { continue }

            // TODO: How am I going to determine state for each key?
            // Plan it out first. Write it out. What's the best way to do this? 
        }
        
        for keyView in self.keyViews {
            guard let key = keyView.key else { continue }
            guard let state = keyStates[key] else { continue }
            keyView.state = state
        }
    }
}

extension KeyboardView: KeyViewDelegate {
    func didSelect(key: Key) {
        self.delegate?.didSelect(key: key)
    }
}
