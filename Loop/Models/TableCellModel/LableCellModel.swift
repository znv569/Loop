//
//  LableCellModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

enum TypeText {
    case text, html
}

class LableCellModel: TableCellModel {
    // MARK: Properties

    // MARK: System

    override var cellIdentifier: String {
        LabelCell.className
    }

    // MARK: Stored

    @objc dynamic var text: String?
    @objc dynamic var attributedString: NSAttributedString?
    
    let numberOfLines: Int
    let font: UIFont
    let textColor: UIColor
    let insets: UIEdgeInsets
    let type: TypeText
    let alignment: NSTextAlignment

    // MARK: - Init

    init(font: UIFont,
         textColor: UIColor,
         numberOfLines: Int = 1,
         insets: UIEdgeInsets = .zero,
         type: TypeText = .text,
         alignment: NSTextAlignment = .left) {
        self.text = nil
        self.numberOfLines = numberOfLines
        self.attributedString = nil
        self.font = font
        self.textColor = textColor
        self.insets = insets
        self.type = type
        self.alignment = alignment
    }
}
