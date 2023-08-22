//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

class GridView: UIView {
    
    var tileViews: [[TileView]] = []
    let (numRows, numColumns): (Int, Int)
    var activeAttempt = 0

    public var currentWordAttempt: String {
        self.tileViews[self.activeAttempt].compactMap({ $0.key?.rawValue }).joined()
    }
    
    init(game: Game) {
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
    
    public func animateReveal(keyStates: [KeyState], completion: @escaping (() -> Void)) {
        let currentActiveAttemptIndex = self.activeAttempt
        for i in 0 ..< self.tileViews[currentActiveAttemptIndex].count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2), execute: {
                self.tileViews[currentActiveAttemptIndex][i].animateReveal(state: keyStates[i], completion: {
                    if i == (self.tileViews[currentActiveAttemptIndex].count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    public func animateSolve(completion: @escaping (() -> Void)) {
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
    
    public func animateActiveAttemptRowWithError() {
        for tile in self.tileViews[self.activeAttempt] {
            tile.animateError()
        }
    }
}
