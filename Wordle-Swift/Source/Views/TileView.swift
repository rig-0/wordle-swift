//
//  TileView.swift
//  ©️ 2023 0100
//

import UIKit

class TileView: UIView {
    
    public var key: Key? {
        didSet {
            self.update()
        }
    }
    
    public var state: KeyState = .tbd {
        didSet {
            self.update()
        }
    }
    
    private var wrapperView: UIView!
    private var wrapperHorizontalConstraint: NSLayoutConstraint!
    private var wrapperVerticalConstraint: NSLayoutConstraint!
    private var labelView: UILabel!
    
    init(key: Key? = nil) {
        super.init(frame: .zero)
        self.key = key
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        let wrapperView = UIView()
        self.addSubview(wrapperView)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.wrapperHorizontalConstraint = wrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        self.wrapperHorizontalConstraint.isActive = true
        self.wrapperVerticalConstraint = wrapperView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        self.wrapperVerticalConstraint.isActive = true
        self.wrapperView = wrapperView
        
        let labelView = UILabel()
        labelView.textColor = .black
        labelView.font = UIFont.App.tileFont
        labelView.textAlignment = .center
        wrapperView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        labelView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor).isActive = true
        labelView.heightAnchor.constraint(equalTo: self.wrapperView.heightAnchor).isActive = true
        self.labelView = labelView
        
        update()
    }
    
    private func update() {
        self.labelView.text = self.key?.rawValue
        
        if self.state == .tbd {
            self.wrapperView.layer.borderWidth = 2
            self.labelView.textColor = .black
            if let _ = self.key {
                self.wrapperView.layer.borderColor = UIColor.App.keyStateTbd.cgColor
            } else {
                self.wrapperView.layer.borderColor = UIColor.App.keyStateEmpty.cgColor
            }
        } else {
            self.wrapperView.layer.borderWidth = 0
            self.labelView.textColor = .white
            self.wrapperView.backgroundColor = backgroundColorForState(self.state)
        }
    }
    
    private func backgroundColorForState(_ state : KeyState) -> UIColor {
        switch state {
        case .correct:
            return UIColor.App.keyStateCorrect
        case .present:
            return UIColor.App.keyStatePresent
        default:
            return UIColor.App.keyStateAbsent
        }
    }
    
    public func animateInput(key: Key, completion: @escaping (() -> Void)) {
        
        // 1. Switch state to key, default styling, no animation
        self.key = key
        
        // 2. Fade down to 0.4 alpha, shrink to 0.95, no animation
        self.alpha = 0.4
        self.wrapperView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
        
        // 3. Alpha back to 1.0, Scale up to 1.05, just shy of touching neighbors
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
            self.wrapperView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
        }, completion: { finished in
            
            // 4. Scale back down to 1.0
            UIView.animate(withDuration: 0.1, animations: {
                self.wrapperView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                completion()
            })
        })
        
    }
    
    public func animateReveal(state: KeyState, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.2, animations: {
            self.wrapperView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.001);
        }, completion: { finished in
            self.state = state
            UIView.animate(withDuration: 0.15, animations: {
                self.wrapperView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            }, completion: { finished in
                completion()
            })
        })
    }
    
    public func animateSolve(completion: @escaping (() -> Void)) {
        let offset = 30.0
        self.wrapperVerticalConstraint.constant = -offset
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion: { finished in
            self.wrapperVerticalConstraint.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, animations: {
                self.layoutIfNeeded()
            }, completion: { finished in
                completion()
            })
        })
    }
    
    public func animateShake() {
        let duration = 0.05
        let offset = 3.0
        self.animate(offset: -offset/2, duration: duration) {
            self.animate(offset: offset/2, duration: duration) {
                self.animate(offset: -offset/2, duration: duration) {
                    self.animate(offset: offset, duration: duration) {
                        self.animate(offset: -offset, duration: duration) {
                            self.animate(offset: offset, duration: duration) {
                                self.animate(offset: -offset/2, duration: duration) {
                                    self.animate(offset: offset/2, duration: duration) {
                                        self.animate(offset: -offset/2, duration: duration * 1.5) {
                                            self.animate(offset: 0, duration: duration * 1.5) {
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func animate(offset: CGFloat, duration: CGFloat, completion: @escaping (() -> Void)) {
        self.wrapperHorizontalConstraint.constant = offset
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        }, completion: { finished in
            completion()
        })
    }
}

