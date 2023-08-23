//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

class GridView: UIView {
    
    var tileViews: [[TileView]] = []
//    var activeAttempt = 0

    init(game: Game) {
        super.init(frame: .zero)
        self.setupView(numRows: game.numberOfAttempts, numColumns: game.wordLength)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(numRows: Int, numColumns: Int) {
        
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
        for _ in 0 ..< numRows {
            
            let tileRow = UIStackView()
            tileRow.axis = .horizontal
            tileRow.spacing = 5
            gridView.addArrangedSubview(tileRow)
            
            var tileViews: [TileView] = []
            
            // Number of characters per attempt
            for _ in 0 ..< numColumns {
                let tileView = TileView()
                tileRow.addArrangedSubview(tileView)
                tileViews.append(tileView)
            }
            
            self.tileViews.append(tileViews)
        }
    }
    
    public func deleteLast(attemptIndex: Int) {
        for tile in self.tileViews[attemptIndex].reversed() {
            if tile.key != nil {
                tile.key = nil
                return
            }
        }
    }
    
    public func append(key: Key, attemptIndex: Int) {
        for tile in self.tileViews[attemptIndex] {
            if tile.key == nil {
                tile.animateInput(key: key, completion: {})
                return
            }
        }
    }
    
    public func animateReveal(keyStates: [(Key, KeyState)], attemptIndex: Int, completion: @escaping (() -> Void)) {
        for i in 0 ..< self.tileViews[attemptIndex].count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2), execute: {
                self.tileViews[attemptIndex][i].animateReveal(state: keyStates[i].1, completion: {
                    if i == (self.tileViews[attemptIndex].count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    public func animateSolve(attemptIndex: Int, completion: @escaping (() -> Void)) {
        for i in 0 ..< self.tileViews[attemptIndex].count {
            let delay = i > 0 ? 0.05 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.10) + delay + 0.3, execute: {
                self.tileViews[attemptIndex][i].animateSolve(completion: {
                    if i == (self.tileViews[attemptIndex].count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    public func animateActiveAttemptRowWithError(attemptIndex: Int) {
        for tile in self.tileViews[attemptIndex] {
            tile.animateError()
        }
    }
}
