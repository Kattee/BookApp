//
//  Int+randomNumber.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import Foundation

extension Int {
    
    /// return random number
    var randomNumber: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}
