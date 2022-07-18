//
//  TableCellModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 18.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

public protocol TableCellIdentifiable {
    var cellHeight: CGFloat { get }
    var cellIdentifier: String { get }
    var userInfo: [String: Any] { get set }
}

open class TableCellModel: TableCellIdentifiable {
    // MARK: Properties

    open var cellIdentifier: String {
        ""
    }

    open var cellHeight: CGFloat {
        UITableView.automaticDimension
    }

    open var userInfo: [String: Any] = [:]

    // MARK: Initialization

    public init() {}
}
