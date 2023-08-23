//
//  GridView.swift
//  ©️ 2023 0100
//

import UIKit

class GridView: UIView {
    
    private var rows: [GridRowView] = []
    private let kSpacing = 5.0
    
    init(numRows: Int, numColumns: Int) {
        super.init(frame: .zero)
        self.setupView(numRows: numRows, numColumns: numColumns)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(numRows: Int, numColumns: Int) {
        
        // Primary grid view that contains all tiles
        let gridView = UIStackView()
        gridView.axis = .vertical
        gridView.spacing = self.kSpacing
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // Number of attempts
        for _ in 0 ..< numRows {
            let tileRow = GridRowView(numColumns: numColumns)
            gridView.addArrangedSubview(tileRow)
            self.rows.append(tileRow)
        }
    }
    
    public func deleteLast(attemptIndex: Int) {
        self.rows[attemptIndex].deleteLast()
    }
    
    public func append(key: Key, attemptIndex: Int) {
        self.rows[attemptIndex].append(key: key)
    }
    
    public func animateReveal(keyStates: [(Key, KeyState)], attemptIndex: Int, completion: @escaping (() -> Void)) {
        self.rows[attemptIndex].animateReveal(keyStates: keyStates, completion: completion)
    }
    
    public func animateSolve(attemptIndex: Int, completion: @escaping (() -> Void)) {
        self.rows[attemptIndex].animateSolve(completion: completion)
    }
    
    public func animateError(attemptIndex: Int) {
        self.rows[attemptIndex].animateError()
    }
}
