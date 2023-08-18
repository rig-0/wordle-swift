//
//  GameView.swift
//  ©️ 2023 0100
//

import UIKit

class GameView: UIView {
    
    private var gridView: GridView!
    private var keyboardView: KeyboardView!
    private var toastStackView: ToastStackView!
    
    init() {
        super.init(frame: .zero)
        self.setupView()
        
        // Start Game Instance
        let _ = Game.instance.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let keyboardView = KeyboardView()
        keyboardView.delegate = self
        self.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        keyboardView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.keyboardView = keyboardView
        
        let gridCenterView = UIView()
        self.addSubview(gridCenterView)
        gridCenterView.translatesAutoresizingMaskIntoConstraints = false
        gridCenterView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridCenterView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gridCenterView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gridCenterView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor, constant: -20).isActive = true
        
        let gridView = GridView()
        gridView.delegate = self
        gridCenterView.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: gridCenterView.leadingAnchor, constant: 10).isActive = true
        gridView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gridView.centerYAnchor.constraint(equalTo: gridCenterView.centerYAnchor).isActive = true
        self.gridView = gridView
        
        let toastStackView = ToastStackView()
        self.addSubview(toastStackView)
        toastStackView.translatesAutoresizingMaskIntoConstraints = false
        toastStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        toastStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        toastStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        toastStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.toastStackView = toastStackView
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
    
    func shouldPresentToast(type: ToastItemType) {
        self.toastStackView.addToastItem(type: type)
    }
}
