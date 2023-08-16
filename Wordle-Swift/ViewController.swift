//
//  ViewController.swift
//  ©️ 2023 0100
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView()
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let labelView = UILabel()
        labelView.font = UIFont.App.wordleFont
        labelView.text = "Wordle // Swift"
        labelView.textColor = .black
        headerView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        labelView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12).isActive = true
        
        let dividerView = UIView()
        headerView.addSubview(dividerView)
        dividerView.backgroundColor = UIColor(rgb: (212, 214, 218))
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let gameView = GameView()
        self.view.addSubview(gameView)
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        gameView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        gameView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        gameView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}
