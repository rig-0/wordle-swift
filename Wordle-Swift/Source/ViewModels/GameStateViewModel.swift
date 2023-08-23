//
//  GameStateViewModel.swift
//  ©️ 2023 0100
//

import Foundation

class GameStateViewModel {
    
    private var game: Game!
    private var gameState: GameState = .playing
    private var storedAttempts: [[(Key, KeyState)]] = [[]]
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
        guard self.gameState == .playing else { return }
        guard key != .__ else { return }
        let attemptIndex = self.storedAttempts.count - 1
        
        if key == .ENTER {
            self.inputEnter()
            
        } else if key == .DELETE {
            guard let lastAttempt = self.storedAttempts.last else { return }
            let deleted = lastAttempt.dropLast()
            self.storedAttempts[self.storedAttempts.count - 1] = Array(deleted)
            self.gridView.deleteLast(attemptIndex: attemptIndex)
            
        } else {
            guard var lastAttempt = self.storedAttempts.last else { return }
            guard lastAttempt.count < (self.game.wordLength) else { return }
            lastAttempt.append((key, .tbd))
            self.storedAttempts[self.storedAttempts.count - 1] = lastAttempt
            self.gridView.append(key: key, attemptIndex: attemptIndex)
        }
    }
    
    public func inputEnter() {
        guard self.gameState == .playing else { return }
        let attemptedWord = self.storedAttempts.last?.compactMap({ $0.0.rawValue }).joined() ?? ""
        let attemptIndex = self.storedAttempts.count - 1
        
        // Determine if we have a complete word attempt
        if attemptedWord.count == self.game.wordLength {
            
            // Determine that the attemped word is valid
            guard self.game.isValid(attemptedWord: attemptedWord) else {
                
                // Invalid - Word is not in word list
                self.gridView.animateError(attemptIndex: attemptIndex)
                self.toastStackView.addToastItem(type: .notInWordList)
                return
            }
            
            // Pause to prevent input during subsequent animations
            self.gameState = .paused
            
            let keyStates = self.tileKeyStates(with: attemptedWord)
            self.storedAttempts[self.storedAttempts.count - 1] = keyStates
            self.gridView.animateReveal(keyStates: keyStates, attemptIndex: attemptIndex, completion: {
                
                // Update keyboard key states (this is done post-reveal)
                let keyStates = self.keyboardKeyStates(with: self.storedAttempts)
                self.keyboardView.update(keyStates: keyStates)
                
                // Determine if word is correct
                if self.game.isCorrect(attemptedWord: attemptedWord) {
                    
                    // Correct word - Winner
                    self.presentWinToast()
                    self.gridView.animateSolve(attemptIndex: attemptIndex, completion: {
                        self.gameState = .win
                    })
                    
                } else {
                    if self.storedAttempts.count == self.game.numberOfAttempts {
                        // Game Over
                        self.gameState = .lose
                    } else {
                        // Resume game - Next Attempt
                        self.gameState = .playing
                        self.storedAttempts.append([])
                    }
                }
            })
        }
        else {
            // Incomplete word attempt
            self.gridView.animateError(attemptIndex: attemptIndex)
            self.toastStackView.addToastItem(type: .notEnoughLetters)
        }
    }
    
    public func presentWinToast() {
        var toastType: ToastItemType
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
