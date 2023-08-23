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
    
    private let rows: [[Key]] =
    [
        [.Q, .W, .E, .R, .T, .Y, .U, .I, .O, .P ],
        [.__, .A, .S, .D, .F, .G, .H, .J, .K, .L, .__],
        [.ENTER, .Z, .X, .C, .V, .B, .N, .M, .DELETE]
    ]
    
    private let kSpacingBetweenKeys = 5.0
    private var keyViews: [KeyView] = []
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Determine standard key size, assume first row is all standard characters
        let keysPerRow = rows.first?.count ?? 0
        let availableWidth: CGFloat = self.frame.width
        let widthWithouthSpacing = availableWidth - CGFloat(kSpacingBetweenKeys * CGFloat(keysPerRow - 1))
        let standardKeyWidth = widthWithouthSpacing / CGFloat(keysPerRow)
        self.keyViews.forEach { $0.updateKeySizeWithStandardWidth(standardKeyWidth) }
    }
    
    func setupView() {
        
        // Primary grid view that contains all tiles
        let gridView = UIStackView()
        gridView.axis = .vertical
        gridView.spacing = self.kSpacingBetweenKeys
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
            rowView.spacing = self.kSpacingBetweenKeys
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
    
    public func update(keyStates: [Key : KeyState]) {
        for keyState in keyStates {
            let keyView = self.keyViews.first(where: { $0.key == keyState.key })
            keyView?.state = keyState.value
        }
    }
}

extension KeyboardView: KeyViewDelegate {
    func didSelect(key: Key) {
        self.delegate?.didSelect(key: key)
    }
}
