//
//  UIColorExt.swift
//
//  Created by Maulik on 18/07/20.
//  Copyright © 2020 Lets Explore. All rights reserved.

import UIKit

extension UIColor {
 
    
    class func themeOrange() -> UIColor {
        return UIColor(named: "themeOrange")!
    }
    
    class func themeBlue() -> UIColor {
        return UIColor(named: "themeBlue")!
    }
    
    
    
    //example of Hex string
    class var customGreen: UIColor {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }
    
    class func cardColor() -> UIColor {
        return UIColor(named: "CardColor")!
    }
    
    class func appBtnColor() -> UIColor {
        return UIColor(named: "AppBtnColor")!
    }
  
    class func appShadowColor() -> UIColor {
        return UIColor(named: "ShadowColor")!
    }
    
    
   
    class func rgb(fromHex: Int) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    private class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
