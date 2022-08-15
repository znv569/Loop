//
//  TextFieldCellModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 06.08.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

class AddFoodCellModel: TableCellModel {
    
    // MARK: Properties

    // MARK: System

    override var cellIdentifier: String {
        AddFoodCell.className
    }

    // MARK: Stored
    var name: String = ""
    var carb: Double = 0
    var fat: Double = 0
    var protein: Double = 0
    var cal: Double = 0

    // MARK: - Init

}
