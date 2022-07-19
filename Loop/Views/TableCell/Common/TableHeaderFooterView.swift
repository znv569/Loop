//
//  TableHeaderFooterView.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

public protocol TableHeaderFooterViewIdentifiable {
    var viewIdentifier: String { get }
    var viewHeight: CGFloat { get }
    var viewEstimatedHeight: CGFloat { get }
    var userInfo: [String: Any] { get set }
}

open class TableHeaderFooterViewModel: TableHeaderFooterViewIdentifiable {
    // MARK: Properties

    open var viewIdentifier: String {
        ""
    }

    open var viewHeight: CGFloat {
        UITableView.automaticDimension
    }

    open var viewEstimatedHeight: CGFloat {
        50.0
    }

    open var userInfo: [String: Any] = [:]

    // MARK: Initialization

    public init() {}
}
