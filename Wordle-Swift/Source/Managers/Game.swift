//
//  Game.swift
//  ©️ 2023 0100
//

import Foundation

class Game {
    
    static let instance = Game()
    
    public var gameState: GameState = .playing
    public var correctWord: String
    public var wordList: WordList
    public let numberOfAttempts = 6
    public var activeAttempt = 0
    
    init() {
        let wordList = WordListParser.fetch()
        self.wordList = wordList
        self.correctWord = ""
    }
    
    public func start() {
        self.correctWord = wordList.starters.randomElement()?.uppercased() ?? ""
        print("Word:", correctWord)
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
        for _ in 0 ..< self.correctWord.count {
            keyStates.append(.tbd)
        }
        
        var discardArray = Array(Game.instance.correctWord)
        
        for (i, letter) in Array(attemptedWord).enumerated() {
            if String(letter) == String(Array(Game.instance.correctWord)[i]) {
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

