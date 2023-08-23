//
//  GridRowView.swift
//  ©️ 2023 0100
//

import UIKit

class GridRowView: UIStackView {
    
    private var tileViews: [TileView] = []
    private let kSpacing = 5.0
    
    init(numColumns: Int) {
        super.init(frame: .zero)
        self.setupView(numColumns: numColumns)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(numColumns: Int) {
        self.axis = .horizontal
        self.spacing = self.kSpacing
        
        var tileViews: [TileView] = []
        
        // Number of characters per attempt
        for _ in 0 ..< numColumns {
            let tileView = TileView()
            self.addArrangedSubview(tileView)
            tileViews.append(tileView)
        }
        
        self.tileViews = tileViews
    }
    
    public func deleteLast() {
        for tile in self.tileViews.reversed() {
            if tile.key != nil {
                tile.key = nil
                return
            }
        }
    }
    
    public func append(key: Key) {
        for tile in self.tileViews {
            if tile.key == nil {
                tile.animateInput(key: key, completion: {})
                return
            }
        }
    }
    
    // MARK: Animation Methods
    
    public func animateReveal(keyStates: [(Key, KeyState)], completion: @escaping (() -> Void)) {
        for i in 0 ..< self.tileViews.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2), execute: {
                self.tileViews[i].animateReveal(state: keyStates[i].1, completion: {
                    if i == (self.tileViews.count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    public func animateSolve(completion: @escaping (() -> Void)) {
        for i in 0 ..< self.tileViews.count {
            let delay = i > 0 ? 0.05 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.10) + delay + 0.3, execute: {
                self.tileViews[i].animateSolve(completion: {
                    if i == (self.tileViews.count - 1) {
                        completion()
                    }
                })
            })
        }
    }
    
    public func animateError() {
        for tile in self.tileViews {
            tile.animateError()
        }
    }
}
