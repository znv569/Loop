//
//  FoodEntryCellModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 18.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation

class FoodEntryCellModel: TableCellModel {
    
    open var cellIdentifier: String {
        FoodEntryCell.identifier
    }
    
    enum ShowMode {
        case full
        case short
    }
    
    var mode: ShowMode {
        didSet {
            if oldValue != mode {
                updateMode?()
            }
        }
    }
    var count: Double {
        didSet {
            if oldValue != count {
                updateView?()
            }
        }
    }
    var food: FoodCoreData {
        didSet {
            if oldValue != food {
                updateView?()
            }
        }
    }
    var selectedUnit: UnitCoreData? {
        didSet {
            if oldValue != selectedUnit {
                updateView?()
            }
        }
    }
    
    var updateView: (() -> Void)?
    var updateMode: (() -> Void)?
    var startEditing: (() -> Void)?
    
    init(food: FoodCoreData, mode: ShowMode = .full) {
        self.mode = mode
        self.food = food
        self.selectedUnit = food.units?.firstObject as? UnitCoreData
        self.count = 0
        super.init()
    }
    
}
