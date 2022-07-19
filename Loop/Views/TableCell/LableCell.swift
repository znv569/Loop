//
//  LableCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

class LabelCell: TableCell {
    // MARK: Components

    private let label: UILabel = .init()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup methods

    private func setupLayout() {
        label.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func setupComponents() {
        contentView.addSubview(label)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        label.isUserInteractionEnabled = true
    }
    private var observationText: NSKeyValueObservation?
    private var observationAttributed: NSKeyValueObservation?
    
    // MARK: - Update methods

    override func updateViews() {
        guard let model = model as? LableCellModel else {
            return
        }
        label.textColor = model.textColor
        label.font = model.font
        label.numberOfLines = model.numberOfLines
        label.backgroundColor = .clear
        label.textAlignment = model.alignment

        label.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(model.insets.left)
            $0.trailing.equalToSuperview().inset(model.insets.right)
            $0.top.equalToSuperview().inset(model.insets.top)
            $0.bottom.equalToSuperview().inset(model.insets.bottom)
        }
        
        observationText?.invalidate()
        observationText = model.observe(\.text, options: [.old, .new, .initial]) { [weak self] model, change in
            self?.label.text = model.text
            self?.updateLayout()
        }
        observationAttributed?.invalidate()
        observationAttributed = model.observe(\.attributedString, options: [.old, .new, .initial]) { [weak self] model, change in
            self?.label.attributedText = model.attributedString
            self?.updateLayout()
        }
        
    }
 
    private func updateLayout() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.layoutIfNeeded()
            self.layoutDelegate?.didUpdateLayout()
        }
    }

    // MARK: - Actions

}
