//
//  ViewController.swift
//  Wordle-Swift
//
//  Created by RIGO CARBAJAL on 8/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tileRow = UIStackView()
        tileRow.axis = .horizontal
        tileRow.spacing = 5
        self.view.addSubview(tileRow)
        tileRow.translatesAutoresizingMaskIntoConstraints = false
        tileRow.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tileRow.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tileRow.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        for _ in 0 ..< 5 {
            let tile = TileView()
            tileRow.addArrangedSubview(tile)
            tile.translatesAutoresizingMaskIntoConstraints = false
            tile.heightAnchor.constraint(equalTo: tile.widthAnchor, multiplier: 1).isActive = true
        }
    }
}

