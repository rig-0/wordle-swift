//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

enum GameState {
    case playing
    case complete
}

class GridView: UIView {
    
    let kNumberOfAttempts = 6
    let kCharactersPerAttempt = 5
    
    var tileViews: [[TileView]] = []
    var activeAttempt = 0
    var gameState: GameState = .playing
    
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
                self.activeAttempt += 1
                if self.activeAttempt == self.kNumberOfAttempts {
                    self.gameState = .complete
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
}
