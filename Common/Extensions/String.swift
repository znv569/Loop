//
//  String.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

extension String {
    public func htmlToAttributed(color: UIColor, font: UIFont) -> NSAttributedString {
        let htmlPreparation = """
        <!doctype html>
        <html>
        <head>
        <style>
        body {
           font-size: \(font.pointSize)px !important;
           font-family: \(font.fontName);
           color: \(color.hex);
        }
        </style>
        </head>
        <body>
        \(self)
        </body>
        </html>
        """
        print("[html] \(self)")
        guard let htmlData = htmlPreparation.data(using: .unicode, allowLossyConversion: false) else {
            return NSAttributedString(string: self)
        }
        do {
            let attributedString = try NSAttributedString(
                data: htmlData,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                ],
                documentAttributes: nil
            )
            if let nsMutable = attributedString.mutableCopy() as? NSMutableAttributedString {
                return nsMutable.trimmedAttributedString()
            } else {
                return attributedString
            }
        } catch {
            return NSAttributedString(string: self)
        }
    }
}

extension NSMutableAttributedString {
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}
