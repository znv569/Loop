//
//  TableSectionModel.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
}


public protocol TableSectionRepresentable: SectionModelType {
    var items: [TableCellIdentifiable] { get set }
    var header: TableHeaderFooterViewIdentifiable? { get set }
    var footer: TableHeaderFooterViewIdentifiable? { get set }
}

open class TableSectionModel: TableSectionRepresentable {
    public typealias Item = TableCellIdentifiable

    // MARK: Properties

    open var items: [TableCellIdentifiable]
    open var header: TableHeaderFooterViewIdentifiable?
    open var footer: TableHeaderFooterViewIdentifiable?

    // MARK: Initialization

    public init() {
        items = []
    }

    public required init(original _: TableSectionModel, items: [Item]) {
        self.items = items
    }

    public func addItem(_ item: TableCellIdentifiable) {
        items.append(item)
    }
}
