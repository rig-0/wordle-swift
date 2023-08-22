//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

protocol GridViewDelegate: AnyObject {
    func didCompleteAttempt(tileViews: [[TileView]])
    func shouldPresentToast(type: ToastItemType)
}

class GridView: UIView {
    
    public weak var delegate: GridViewDelegate?
    
    var tileViews: [[TileView]] = []
    let (numRows, numColumns): (Int, Int)
    var activeAttempt = 0

    init(numRows: Int, numColumns: Int) {
        self.numRows = numRows
        self.numColumns = numColumns
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        for _ in 0 ..< self.numRows {
            
            let tileRow = UIStackView()
            tileRow.axis = .horizontal
            tileRow.spacing = 5
            gridView.addArrangedSubview(tileRow)
            
            var tileViews: [TileView] = []
            
            // Number of characters per attempt
            for _ in 0 ..< self.numColumns {
                let tileView = TileView()
                tileRow.addArrangedSubview(tileView)
                tileViews.append(tileView)
            }
            
            self.tileViews.append(tileViews)
        }
    }
    
    public func input(key: Key) {
        guard Game.instance.gameState == .playing else { return }
        
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
                
                guard isAttemptValid() else {
                    print("ERROR: Not in word list")
                    self.animateActiveAttemptRowWithError()
                    self.delegate?.shouldPresentToast(type: .notInWordList)
                    return
                }
                
                let tileStates = determineKeyPlacementForAttempt()
                
                Game.instance.gameState = .paused
                
                let currentActiveAttemptIndex = self.activeAttempt
                for i in 0 ..< self.tileViews[currentActiveAttemptIndex].count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2), execute: {
                        self.tileViews[currentActiveAttemptIndex][i].animateReveal(state: tileStates[i], completion: {
                            if i == (self.tileViews[currentActiveAttemptIndex].count - 1) {
                                
                                Game.instance.gameState = .playing
                                
                                self.delegate?.didCompleteAttempt(tileViews: self.tileViews)
                                
                                if self.isAttemptCorrect() {
                                    
                                    Game.instance.gameState = .paused
                                    
                                    switch currentActiveAttemptIndex {
                                    case 0:  self.delegate?.shouldPresentToast(type: .winGenius)
                                    case 1:  self.delegate?.shouldPresentToast(type: .winMagnificent)
                                    case 2:  self.delegate?.shouldPresentToast(type: .winImpressive)
                                    case 3:  self.delegate?.shouldPresentToast(type: .winSplendid)
                                    case 4:  self.delegate?.shouldPresentToast(type: .winGreat)
                                    default: self.delegate?.shouldPresentToast(type: .winPhew)
                                    }
                                    
                                    for i in 0 ..< self.tileViews[currentActiveAttemptIndex].count {
                                        let delay = i > 0 ? 0.05 : 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.10) + delay + 0.3, execute: {
                                            self.tileViews[currentActiveAttemptIndex][i].animateSolve(completion: {
                                                if i == (self.tileViews[currentActiveAttemptIndex].count - 1) {
                                                    print("WIN")
                                                    Game.instance.gameState = .win
                                                }
                                            })
                                        })
                                    }
                                    
                                } else {
                                    self.activeAttempt += 1
                                    if self.activeAttempt == self.numRows {
                                        print("LOSE")
                                        Game.instance.gameState = .lose
                                    }
                                }
                            }
                        })
                    })
                }
                
            } else {
                print("ERROR: Not enough letters")
                self.animateActiveAttemptRowWithError()
                self.delegate?.shouldPresentToast(type: .notEnoughLetters)
            }
        }
        else {
            for tile in self.tileViews[self.activeAttempt] {
                if tile.key == nil {
                    tile.animateInput(key: key, completion: {})
                    return
                }
            }
        }
    }
    
    private func animateActiveAttemptRowWithError() {
        for tile in self.tileViews[self.activeAttempt] {
            tile.animateError()
        }
    }
    
    private func isAttemptValid() -> Bool {
        let attemptWord = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        return Game.instance.wordList.isValid(attemptWord)
    }
    
    private func isAttemptCorrect() -> Bool {
        let attemptWord = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        return attemptWord == Game.instance.correctWord
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
        
        var discardArray = Array(Game.instance.correctWord)
        
        for i in 0 ..< self.tileViews[self.activeAttempt].count {
            let tileKey = self.tileViews[self.activeAttempt][i].key
            if tileKey?.rawValue == String(Array(Game.instance.correctWord)[i]) {
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
