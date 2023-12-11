//
//  UIColor+Extension.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(R:Int, G:Int, B: Int, Opacity: CGFloat = 1.0) {
        let r: CGFloat = CGFloat(R)/255
        let g: CGFloat = CGFloat(G)/255
        let b: CGFloat = CGFloat(B)/255
        self.init(red: r, green: g, blue: b, alpha: Opacity)
    }
    
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class var cellGreen
    : UIColor { return UIColor(red: 0.709, green: 0.8, blue: 0.133, alpha: 1)}
    class var cellGray
    : UIColor { return UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)}
    
}

