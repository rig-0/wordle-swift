//
//  GameView.swift
//  ©️ 2023 0100
//

import UIKit

class GameView: UIView {
    
    private var game: Game!
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
        
        let gridView = GridView(game: self.game)
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
        self.input(key: key)
    }
    
    public func input(key: Key) {
        guard self.game.gameState == .playing else { return }
        
        if key == .DELETE {
            self.gridView.deleteLast()
        }
        else if key == .ENTER {

            // 1. Determine if we have a complete word attempt
            let currentWordAttempt = self.gridView.currentWordAttempt
            if currentWordAttempt.count == self.game.correctWord.count {
                
                // 2. Determine if that word is valid,
                guard self.game.isValid(attemptedWord: currentWordAttempt) else {
                    
                    // If invalid, animate row and present toast
                    self.gridView.animateActiveAttemptRowWithError()
                    self.shouldPresentToast(type: .notInWordList)
                    return
                }
                
                self.game.gameState = .paused
                
                // If word is valid
                // Reveal with row animation
                let keyStates = self.game.tileKeyStates(with: currentWordAttempt)
                self.gridView.animateReveal(keyStates: keyStates, completion: {
                    
                    self.game.gameState = .playing
                    
                    // update keyboard key states
                    let keyStates = self.game.keyboardKeyStates(with: self.gridView.tileViews)
                    self.keyboardView.update(keyStates: keyStates)
                    
                    // 3. Determine if word is correct
                    if self.game.isCorrect(attemptedWord: currentWordAttempt) {
                        // Correct
                        self.game.gameState = .paused
                        self.presentWinToast()
                        self.gridView.animateSolve(completion: {
                            self.game.gameState = .win
                        })
                        
                    } else {
                        // Incorrect
                        self.gridView.activeAttempt += 1
                        if self.gridView.activeAttempt == self.game.numberOfAttempts {
                            self.game.gameState = .lose
                        }
                    }
                })
            }
            else {
                // Incomplete word attempt
                self.gridView.animateActiveAttemptRowWithError()
                self.shouldPresentToast(type: .notEnoughLetters)
            }
        }
        else {
            self.gridView.append(key: key)
        }
    }
    
    public func presentWinToast() {
        switch self.gridView.activeAttempt {
        case 0:  self.shouldPresentToast(type: .winGenius)
        case 1:  self.shouldPresentToast(type: .winMagnificent)
        case 2:  self.shouldPresentToast(type: .winImpressive)
        case 3:  self.shouldPresentToast(type: .winSplendid)
        case 4:  self.shouldPresentToast(type: .winGreat)
        default: self.shouldPresentToast(type: .winPhew)
        }
    }
        
    func shouldPresentToast(type: ToastItemType) {
        self.toastStackView.addToastItem(type: type)
    }

}
