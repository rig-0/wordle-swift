//
//  ViewController.swift
//  ©️ 2023 0100
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gridView = GridView()
        self.view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        gridView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let keyboardView = KeyboardView()
        self.view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        keyboardView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        keyboardView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 20).isActive = true
        
    }
}

