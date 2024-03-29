//
//  GameView.swift
//  ©️ 2023 0100
//

import UIKit

class GameView: UIView {
    
    private var game: Game!
    private var gameStateViewModel: GameStateViewModel!
    private var gridView: GridView!
    private var keyboardView: KeyboardView!
    private var toastStackView: ToastStackView!
    
    init(game: Game) {
        super.init(frame: .zero)
        self.game = game
        self.setupView()
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
        
        let gridView = GridView(numRows: self.game.numberOfAttempts, numColumns: self.game.wordLength)
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
        
        self.gameStateViewModel = GameStateViewModel(
            game: self.game,
            gridView: self.gridView,
            keyboardView: self.keyboardView,
            toastStackView: self.toastStackView
        )
    }
}

extension GameView: KeyboardViewDelegate {
    func didSelect(key: Key) {
        self.gameStateViewModel.input(key: key)
    }
}
