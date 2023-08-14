//
//  GameView.swift
//  ©️ 2023 0100
//

import UIKit

class GameView: UIView {
    
    private var gridView: GridView!
    private var keyboardView: KeyboardView!
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let gridView = GridView()
        gridView.delegate = self
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.gridView = gridView
        
        let keyboardView = KeyboardView()
        keyboardView.delegate = self
        self.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        keyboardView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        keyboardView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 20).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.keyboardView = keyboardView
    }
}

extension GameView: KeyboardViewDelegate {
    func didSelect(key: Key) {
        self.gridView.input(key: key)
    }
}

extension GameView: GridViewDelegate {
    func didCompleteAttempt(tileViews: [[TileView]]) {
        self.keyboardView.updateKeyStates(tileViews: tileViews)
    }
}
