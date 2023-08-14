//
//  UIColor+AppColors.swift
//  ©️ 2023 0100
//

import UIKit

extension UIColor {
    convenience init(rgb: (CGFloat, CGFloat, CGFloat), opacity: CGFloat = 1) {
        self.init(red: rgb.0/255, green: rgb.1/255, blue: rgb.2/255, alpha: opacity)
    }
    
    struct App {
        static var keyStateEmpty: UIColor { UIColor(rgb: (212,214,218)) }
        static var keyStateTbd: UIColor { UIColor(rgb: (136,138,140)) }
        static var keyStateCorrect: UIColor { UIColor(rgb: (121,168,107)) }
        static var keyStatePresent: UIColor { UIColor(rgb: (197,181,102)) }
        static var keyStateAbsent: UIColor { UIColor(rgb: (121,124,126)) }
    }
}
