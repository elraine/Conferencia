//
//  UIColorExtensionHex.swift
//  Conferencia
//
//  Created by Alexis Chan on 31/03/2016.
//  Copyright © 2016 achan. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init( var hex: String) {
        var alpha: Float = 100
        let hexLength = hex.characters.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
            print("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#GGRRBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        if hexLength == 9 {
            // Note: this uses String subscripts as given below
            alpha = hex[7...8].floatValue
            hex = hex[0...6]
        }
        
        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s: NSScanner = NSScanner(string: hex)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt(&rgb)
        
        // Creating the UIColor from hex int
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha / 100)
        )
    }
}

extension String {
    
    /**
     Returns the float value of a string
     */
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    /**
     Subscript to allow for quick String substrings ["Hello"][0...1] = "He"
     */
    subscript (r: Range<Int>) -> String {
        get {
            let start = self.startIndex.advancedBy(r.startIndex)
            let end = self.startIndex.advancedBy(r.endIndex - 1)
            return self.substringWithRange(start..<end)
        }
    }
}