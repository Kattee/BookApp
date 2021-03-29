//
//  UIView+cornerRadius.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

extension UIView {
    
    @IBInspectable
    /// added corner radius property
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}
