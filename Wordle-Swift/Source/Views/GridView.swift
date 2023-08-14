//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

enum GameState {
    case playing
    case win
    case lose
}

class GridView: UIView {
    
    let kNumberOfAttempts = 6
    let kCharactersPerAttempt = 5
    
    var tileViews: [[TileView]] = []
    var activeAttempt = 0
    var gameState: GameState = .playing
    
    let correctWord = "AAAZZ"
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        // Number of attempts
        for _ in 0 ..< self.kNumberOfAttempts {
            
            let tileRow = UIStackView()
            tileRow.axis = .horizontal
            tileRow.spacing = 5
            gridView.addArrangedSubview(tileRow)
            
            var tileViews: [TileView] = []
            
            // Number of characters per attempt
            for _ in 0 ..< self.kCharactersPerAttempt {
                let tileView = TileView()
                tileRow.addArrangedSubview(tileView)
                tileViews.append(tileView)
            }
            
            self.tileViews.append(tileViews)
        }
    }
    
    public func input(key: Key) {
        guard self.gameState == .playing else { return }
        
        if key == .DELETE {
            for tile in self.tileViews[self.activeAttempt].reversed() {
                if tile.key != nil {
                    tile.key = nil
                    return
                }
            }
        }
        else if key == .ENTER {
            let lastTile = self.tileViews[self.activeAttempt].last
            if lastTile?.key != nil {
                
                let tileStates = determineKeyPlacementForAttempt()
                for i in 0 ..< self.tileViews[self.activeAttempt].count {
                    self.tileViews[self.activeAttempt][i].state = tileStates[i]
                }
                
                if isAttemptCorrect() {
                    print("WIN")
                    self.gameState = .win
                } else {
                    self.activeAttempt += 1
                    if self.activeAttempt == self.kNumberOfAttempts {
                        print("LOSE")
                        self.gameState = .lose
                    }
                }
            }
        }
        else {
            for tile in self.tileViews[self.activeAttempt] {
                if tile.key == nil {
                    tile.key = key
                    return
                }
            }
        }
    }
    
    private func isAttemptCorrect() -> Bool {
        let attemptWord = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        return attemptWord == self.correctWord
    }
    
    private func determineKeyPlacementForAttempt() -> [KeyState] {
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
        for _ in self.tileViews[self.activeAttempt] {
            keyStates.append(.tbd)
        }
        
        var discardArray = Array(self.correctWord)
        
        for i in 0 ..< self.tileViews[self.activeAttempt].count {
            let tileKey = self.tileViews[self.activeAttempt][i].key
            if tileKey?.rawValue == String(Array(self.correctWord)[i]) {
                keyStates[i] = .correct
                if let firstIndex = discardArray.firstIndex(of: Character(tileKey?.rawValue ?? "")) {
                    discardArray.remove(at: firstIndex)
                }
            }
        }
        
        for i in 0 ..< self.tileViews[self.activeAttempt].count {
            guard keyStates[i] == .tbd else { continue }
            
            let tileKey = self.tileViews[self.activeAttempt][i].key
            // How many instances of this letter appear in the correct word?
            let instanceCount = discardArray.filter({ String($0) == tileKey?.rawValue }).count
            if instanceCount > 0 {
                keyStates[i] = .present
                if let firstIndex = discardArray.firstIndex(of: Character(tileKey?.rawValue ?? "")) {
                    discardArray.remove(at: firstIndex)
                }
            } else {
                keyStates[i] = .absent
            }
        }
        
        return keyStates
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
