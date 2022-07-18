//
//  TableCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 18.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

protocol TableCellRepresentable: AnyObject {
    var model: TableCellIdentifiable? { get set }
    var layoutDelegate: TableCellLayoutDelegate? { get set }
}

protocol TableCellLayoutDelegate: AnyObject {
    func didUpdateLayout()
}

class TableCell: UITableViewCell, TableCellRepresentable {
    // MARK: Properties

    public var model: TableCellIdentifiable? {
        didSet {
            updateViews()
        }
    }

    weak var layoutDelegate: TableCellLayoutDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }

    // MARK: Setup functions

    open override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    open func setupView() {}

    open func updateViews() {}

    open override func setHighlighted(_ highlighted: Bool, animated _: Bool) {
        if highlighted {
            alpha = 0.4
        } else {
            alpha = 1.0
        }
    }

    open override func setSelected(_: Bool, animated _: Bool) {}
}
