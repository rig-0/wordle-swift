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
    
    var game: Game!
    var tileViews: [[TileView]] = []
    let (numRows, numColumns): (Int, Int)
    var activeAttempt = 0

    init(game: Game) {
        self.game = game
        self.numRows = game.numberOfAttempts
        self.numColumns = game.correctWord.count
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
        guard self.game.gameState == .playing else { return }
        
        if key == .DELETE {
            self.deleteLast()
        }
        else if key == .ENTER {
            let lastTile = self.tileViews[self.activeAttempt].last
            if lastTile?.key != nil {
                
                guard isAttemptValid() else {
                    self.animateActiveAttemptRowWithError()
                    self.delegate?.shouldPresentToast(type: .notInWordList)
                    return
                }

                self.game.gameState = .paused
                self.animateReveal(completion: {
                    self.game.gameState = .playing
                    
                    // Will update keyboard key states
                    self.delegate?.didCompleteAttempt(tileViews: self.tileViews)
                    
                    if self.isAttemptCorrect() {
                        self.game.gameState = .paused
                        self.presentWinToast()
                        self.animateSolve(completion: {
                            self.game.gameState = .win
                        })
                                                
                    } else {
                        self.activeAttempt += 1
                        if self.activeAttempt == self.numRows {
                            self.game.gameState = .lose
                        }
                    }
                })
                
            } else {
                self.animateActiveAttemptRowWithError()
                self.delegate?.shouldPresentToast(type: .notEnoughLetters)
            }
        }
        else {
            self.append(key: key)
        }
    }
    
    public func deleteLast() {
        for tile in self.tileViews[self.activeAttempt].reversed() {
            if tile.key != nil {
                tile.key = nil
                return
            }
        }
    }
    
    public func append(key: Key) {
        for tile in self.tileViews[self.activeAttempt] {
            if tile.key == nil {
                tile.animateInput(key: key, completion: {})
                return
            }
        }
    }
    
    private func animateReveal(completion: @escaping (() -> Void)) {
        let attempt = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        let tileStates = game.tileKeyStates(with: attempt)
        let currentActiveAttemptIndex = self.activeAttempt
        for i in 0 ..< self.tileViews[currentActiveAttemptIndex].count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2), execute: {
                self.tileViews[currentActiveAttemptIndex][i].animateReveal(state: tileStates[i], completion: {
                    if i == (self.tileViews[currentActiveAttemptIndex].count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    private func animateSolve(completion: @escaping (() -> Void)) {
        let currentActiveAttemptIndex = self.activeAttempt
        for i in 0 ..< self.tileViews[currentActiveAttemptIndex].count {
            let delay = i > 0 ? 0.05 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.10) + delay + 0.3, execute: {
                self.tileViews[currentActiveAttemptIndex][i].animateSolve(completion: {
                    if i == (self.tileViews[currentActiveAttemptIndex].count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    private func presentWinToast() {
        switch self.activeAttempt {
        case 0:  self.delegate?.shouldPresentToast(type: .winGenius)
        case 1:  self.delegate?.shouldPresentToast(type: .winMagnificent)
        case 2:  self.delegate?.shouldPresentToast(type: .winImpressive)
        case 3:  self.delegate?.shouldPresentToast(type: .winSplendid)
        case 4:  self.delegate?.shouldPresentToast(type: .winGreat)
        default: self.delegate?.shouldPresentToast(type: .winPhew)
        }
    }
    
    private func animateActiveAttemptRowWithError() {
        for tile in self.tileViews[self.activeAttempt] {
            tile.animateError()
        }
    }
    
    private func isAttemptValid() -> Bool {
        let attemptWord = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        return self.game.wordList.isValid(attemptWord)
    }
    
    private func isAttemptCorrect() -> Bool {
        let attemptWord = self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
        return attemptWord == self.game.correctWord
    }
}
