//
//  ButtonCellModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

class ButtonCellModel: TableCellModel {
    // MARK: Properties

    // MARK: System

    override var cellIdentifier: String {
        ButtonCell.className
    }

    // MARK: Stored

    @objc dynamic var text: String?
    @objc dynamic var attributedString: NSAttributedString?
    @objc dynamic var image: UIImage?
    
    let font: UIFont
    let textColor: UIColor
    let backgroundButtonColor: UIColor
    let backgroundContentView: UIColor
    let insets: UIEdgeInsets
    let corner: CGFloat
    let tintColor: UIColor?
    var action: (() -> Void)?
    let height: CGFloat
    
    // MARK: - Init

    init(font: UIFont,
         textColor: UIColor,
         backgroundButtonColor: UIColor,
         backgroundContentView: UIColor,
         insets: UIEdgeInsets,
         corner: CGFloat,
         tintColor: UIColor?,
         height: CGFloat) {
        self.font = font
        self.textColor = textColor
        self.backgroundButtonColor = backgroundButtonColor
        self.backgroundContentView = backgroundContentView
        self.insets = insets
        self.corner = corner
        self.tintColor = tintColor
        self.height = height
    }
}

