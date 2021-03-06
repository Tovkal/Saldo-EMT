//
//  UIColor.swift
//  SaldoEMT
//
//  Created by Andrés Pizá Bückmann on 05/11/2016.
//  Copyright © 2016 tovkal. All rights reserved.
//

import UIKit

/**
 InputSizeNotValid:     "Invalid input string, must be 6 characters long. Can optionally have '#' as prefix"
 */
public enum UIColorError: Error {
    case inputSizeNotValid, unableToScanHexValue
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }

    public convenience init(_ hexColor: String) throws {
        if hexColor.count != 6 && !(hexColor.count == 7 && hexColor.hasPrefix("#")) {
            throw UIColorError.inputSizeNotValid
        }

        var hexString = hexColor

        if hexColor.hasPrefix("#") {
            hexString = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 1)...])
        }

        var hexValue: UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            throw UIColorError.unableToScanHexValue
        }

        let divisor = CGFloat(255)
        let red     = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hexValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hexValue & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
