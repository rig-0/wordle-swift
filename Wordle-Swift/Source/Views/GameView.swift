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
        
        self.gameStateViewModel = GameStateViewModel(game: self.game,
                                                     gridView: self.gridView,
                                                     keyboardView: self.keyboardView,
                                                     toastStackView: self.toastStackView)
    }
}

extension GameView: KeyboardViewDelegate {
    func didSelect(key: Key) {
        self.gameStateViewModel.input(key: key)
    }
}

class GameStateViewModel {
    
    private var game: Game!
    private var gridView: GridView!
    private var keyboardView: KeyboardView!
    private var toastStackView: ToastStackView!
    
    init(game: Game,
         gridView: GridView,
         keyboardView: KeyboardView,
         toastStackView: ToastStackView) {
        self.game = game
        self.gridView = gridView
        self.keyboardView = keyboardView
        self.toastStackView = toastStackView
    }
    
    public func input(key: Key) {
        guard self.game.gameState == .playing else { return }
        
        if key == .DELETE {
            self.gridView.deleteLast()
        }
        else if key == .ENTER {

            // 1. Determine if we have a complete word attempt
            let currentWordAttempt = self.gridView.currentWordAttempt
            if currentWordAttempt.count == self.game.wordLength {
                
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
                let keyStates = self.tileKeyStates(with: currentWordAttempt)
                self.gridView.animateReveal(keyStates: keyStates, completion: {
                    
                    self.game.gameState = .playing
                    
                    // update keyboard key states
                    let keyStates = self.keyboardKeyStates(with: self.gridView.tileViews)
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
    
    public func keyboardKeyStates(with tileViews: [[TileView]]) -> [Key : KeyState] {
        
        var keyStates: [Key : KeyState] = [:]
        for key in Key.allCases {
            keyStates[key] = .tbd
        }
        
        let tileViews = tileViews.joined()
        let absentTiles = tileViews.filter({ $0.state == .absent })
        for tileView in absentTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        let presentTiles = tileViews.filter({ $0.state == .present })
        for tileView in presentTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        let correctTiles = tileViews.filter({ $0.state == .correct })
        for tileView in correctTiles {
            guard let key = tileView.key else { continue }
            keyStates[key] = tileView.state
        }
        
        return keyStates
    }
    
    public func tileKeyStates(with attemptedWord: String) -> [KeyState] {
        /*
         ## Logic for checking our key placement per attempt
         
         1. We start by initializing a state array with a .tbd state for each character
         2. Create an array that we'll use to 'discard' keys that have been inputted correctly.
         Here, the placement doesn't matter. It's simply an array of all available keys in
         the correct word.
         3. Run through our attempt and figure out which letters are correct. Each time a letter
         is correct, remove the corresponding letter from the discard pile. This is important
         in correctly determining the crucial step of "which letters are misplaced".
         4. Run through our attempt one more time, this time, determining which keys are
         absent and which are simply misplaced.
         
         ### Consider the following test:
         ```
         Correct Word: AAAZZ
         Attempt: AAAAA
         States should be: [.correct, .correct, .correct, .absent, .absent]
         Attempt: ZZZZZ
         States should be: [.absent, .absent, .absent, .correct, .correct]
         ```
         
         If we don't do this logic correctly, with ZZZZZ, we'll check the first character,
         see that it's misplaced, and incorrectly assign it a state of .present. This is
         why it's important to check all correct placements first, and track our discard pile.
         */
        
        var keyStates: [KeyState] = []
        for _ in 0 ..< self.game.wordLength {
            keyStates.append(.tbd)
        }

        guard let correctWord = self.game.correctWord else { return keyStates }

        var discardArray = Array(correctWord)
        
        for (i, letter) in Array(attemptedWord).enumerated() {
            if String(letter) == String(Array(correctWord)[i]) {
                keyStates[i] = .correct
                if let firstIndex = discardArray.firstIndex(of: letter) {
                    discardArray.remove(at: firstIndex)
                }
            }
        }
        
        for (i, letter) in Array(attemptedWord).enumerated() {
            guard keyStates[i] == .tbd else { continue }
            
            // How many instances of this letter appear in the correct word?
            let instanceCount = discardArray.filter({ String($0) == String(letter) }).count
            if instanceCount > 0 {
                keyStates[i] = .present
                if let firstIndex = discardArray.firstIndex(of: letter) {
                    discardArray.remove(at: firstIndex)
                }
            } else {
                keyStates[i] = .absent
            }
        }
        
        return keyStates
    }
}
