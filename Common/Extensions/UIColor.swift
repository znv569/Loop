//
//  UIColor.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    private static var colors: [String: UIColor] = [:]

    static func hex(hex: String, alpha: CGFloat = 1) -> UIColor {
        let colorString = "\(hex)_\(alpha)"
        if let color = UIColor.colors[colorString] {
            return color
        } else {
            let color = UIColor(hex: hex, alpha: alpha)
            UIColor.colors[colorString] = color
            return color
        }
    }

    private convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            guard let sharpIndex = hexWithoutSymbol.firstIndex(of: "#") else {
                self.init(red: 0,
                          green: 0,
                          blue: 0,
                          alpha: 1)
                return
            }
            hexWithoutSymbol = String(hexWithoutSymbol[sharpIndex...])
        }

        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt: UInt64 = 0x0
        scanner.scanHexInt64(&hexInt)

        var red: UInt64 = 0x0
        var green: UInt64 = 0x0
        var blue: UInt64 = 0x0
        switch hexWithoutSymbol.count {
        case 3: // #RGB
            red = ((hexInt >> 4) & 0xF0 | (hexInt >> 8) & 0x0F)
            green = ((hexInt >> 0) & 0xF0 | (hexInt >> 4) & 0x0F)
            blue = ((hexInt << 4) & 0xF0 | hexInt & 0x0F)
        case 6: // #RRGGBB
            red = (hexInt >> 16) & 0xFF
            green = (hexInt >> 8) & 0xFF
            blue = hexInt & 0xFF
        default:
            break
        }

        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }
    
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255) << 0

        return String(format: "#%06x", rgb)
    }

}
