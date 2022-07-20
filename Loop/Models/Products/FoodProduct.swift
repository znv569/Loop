//
//  FoodModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation

struct FoodProduct: Codable {
    let title: String
    let brand: String
    let tags: String
    let units: [UnitsProduct]
    
    struct UnitsProduct: Codable {
        let name: String
        let carb: Double
        let protein: Double
        let fat: Double
        let kkal: Double
    }
}
