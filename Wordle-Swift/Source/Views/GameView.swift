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
    private var gameState: GameState = .playing
    private var gridView: GridView!
    private var keyboardView: KeyboardView!
    private var toastStackView: ToastStackView!
    private var storedAttempts: [[(Key, KeyState)]] = [[]]
    
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
        guard self.gameState == .playing else { return }
        guard key != .__ else { return }
        if key == .ENTER {
            self.inputEnter()
        } else if key == .DELETE {
            guard let lastAttempt = self.storedAttempts.last else { return }
            let deleted = lastAttempt.dropLast()
            self.storedAttempts[self.storedAttempts.count - 1] = Array(deleted)
            print(self.storedAttempts)
            
            self.gridView.deleteLast()
        } else {
            guard var lastAttempt = self.storedAttempts.last else { return }
            guard lastAttempt.count < (self.game.wordLength) else { return }
            lastAttempt.append((key, .tbd))
            self.storedAttempts[self.storedAttempts.count - 1] = lastAttempt
            print(self.storedAttempts)
            
            self.gridView.append(key: key)
        }
    }
    
    public func inputEnter() {
        guard self.gameState == .playing else { return }
        let attemptedWord = self.storedAttempts.last?.compactMap({ $0.0.rawValue }).joined() ?? ""
        let attemptIndex = self.storedAttempts.count
        
        // Determine if we have a complete word attempt
        if attemptedWord.count == self.game.wordLength {
                        
            // Determine that the attemped word is valid
            guard self.game.isValid(attemptedWord: attemptedWord) else {
                
                // If invalid, animate row and present toast
                self.gridView.animateActiveAttemptRowWithError()
                self.toastStackView.addToastItem(type: .notInWordList)
                return
            }
            
            // Determine tile states for attempted word
            let keyStates = self.tileKeyStates(with: attemptedWord)
            self.storedAttempts[self.storedAttempts.count - 1] = keyStates

            self.gameState = .paused
            
            // If word is valid
            // Reveal with row animation
            self.gridView.animateReveal(keyStates: keyStates, completion: {
                
                self.gameState = .playing
                
                // update keyboard key states
                let keyStates = self.keyboardKeyStates(with: self.storedAttempts)
                self.keyboardView.update(keyStates: keyStates)
                
                // 3. Determine if word is correct
                if self.game.isCorrect(attemptedWord: attemptedWord) {
                    // Correct
                    self.gameState = .paused
                    self.presentWinToast()
                    self.gridView.animateSolve(completion: {
                        self.gameState = .win
                    })
                    
                } else {
                    // Incorrect
                    if self.storedAttempts.count == self.game.numberOfAttempts {
                        self.gameState = .lose
                    } else {
                        self.storedAttempts.append([])
                    }
                }
            })
        }
        else {
            // Incomplete word attempt
            self.gridView.animateActiveAttemptRowWithError()
            self.toastStackView.addToastItem(type: .notEnoughLetters)
        }
    }
    
    public func presentWinToast() {
        var toastType: ToastItemType = .winPhew
        switch self.storedAttempts.count {
        case 0:  toastType = .winGenius
        case 1:  toastType = .winMagnificent
        case 2:  toastType = .winImpressive
        case 3:  toastType = .winSplendid
        case 4:  toastType = .winGreat
        default: toastType = .winPhew
        }
        self.toastStackView.addToastItem(type: toastType)
    }
    
    public func keyboardKeyStates(with storedAttempts: [[(Key, KeyState)]]) -> [Key : KeyState] {
        
        var keyStates: [Key : KeyState] = [:]
        for key in Key.allCases {
            keyStates[key] = .tbd
        }
        
        let storedAttempts = storedAttempts.joined()
        let absentKeys = storedAttempts.filter({ $0.1 == .absent })
        for item in absentKeys {
            keyStates[item.0] = item.1
        }
        
        let presentKeys = storedAttempts.filter({ $0.1 == .present })
        for item in presentKeys {
            keyStates[item.0] = item.1
        }
        
        let correctKeys = storedAttempts.filter({ $0.1 == .correct })
        for item in correctKeys {
            keyStates[item.0] = item.1
        }
        
        return keyStates
    }
    
    public func tileKeyStates(with attemptedWord: String) -> [(Key, KeyState)] {
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
        
        var keyStates: [(Key, KeyState)] = []
        for (_, letter) in Array(attemptedWord).enumerated() {
            guard let key = Key(rawValue: String(letter).uppercased()) else { return [] }
            keyStates.append((key, .tbd))
        }

        guard let correctWord = self.game.correctWord else { return keyStates }

        var discardArray = Array(correctWord)
        
        for (i, letter) in Array(attemptedWord).enumerated() {
            if String(letter) == String(Array(correctWord)[i]) {
                keyStates[i].1 = .correct
                if let firstIndex = discardArray.firstIndex(of: letter) {
                    discardArray.remove(at: firstIndex)
                }
            }
        }
        
        for (i, letter) in Array(attemptedWord).enumerated() {
            guard keyStates[i].1 == .tbd else { continue }
            
            // How many instances of this letter appear in the correct word?
            let instanceCount = discardArray.filter({ String($0) == String(letter) }).count
            if instanceCount > 0 {
                keyStates[i].1 = .present
                if let firstIndex = discardArray.firstIndex(of: letter) {
                    discardArray.remove(at: firstIndex)
                }
            } else {
                keyStates[i].1 = .absent
            }
        }
        
        return keyStates
    }
}
