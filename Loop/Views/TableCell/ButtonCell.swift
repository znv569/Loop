//
//  ButtonCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 19.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit

class ButtonCell: TableCell {
    // MARK: Components

    private let button: UIButton = .init()

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

    deinit {
        observationText?.invalidate()
        observationAttributed?.invalidate()
        observationImage?.invalidate()
    }
    // MARK: - Setup methods

    private func setupLayout() {
        button.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func setupComponents() {
        contentView.addSubview(button)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.tapBegin(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.tapEnd(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    private var observationText: NSKeyValueObservation?
    private var observationAttributed: NSKeyValueObservation?
    private var observationImage: NSKeyValueObservation?
    
    // MARK: - Update methods

    override func updateViews() {
        guard let model = model as? ButtonCellModel else {
            return
        }
        button.layer.cornerRadius = model.corner
        button.setTitle("", for: .normal)
        button.backgroundColor = model.backgroundButtonColor
        contentView.backgroundColor = model.backgroundContentView
        button.titleLabel?.font = model.font
        
        if let tintColor = model.tintColor {
            button.tintColor = tintColor
        }
        
        button.setTitleColor(model.textColor, for: .normal)
        
        button.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(model.insets.left)
            $0.trailing.equalToSuperview().inset(model.insets.right)
            $0.top.equalToSuperview().inset(model.insets.top)
            $0.bottom.equalToSuperview().inset(model.insets.bottom)
            $0.height.equalTo(model.height)
        }
        
        observationText?.invalidate()
        observationText = model.observe(\.text, options: [.old, .new, .initial]) { [weak self] model, change in
            self?.button.setTitle(model.text, for: .normal)
            self?.updateLayout()
        }
        observationAttributed?.invalidate()
        observationAttributed = model.observe(\.attributedString, options: [.old, .new, .initial]) { [weak self] model, change in
            self?.button.setAttributedTitle(model.attributedString, for: .normal)
            self?.updateLayout()
        }
        observationImage?.invalidate()
        observationImage = model.observe(\.image, options: [.old, .new, .initial]) { [weak self] model, change in
            self?.button.setImage(model.image, for: .normal)
            self?.updateLayout()
        }
        
    }
 
    private func updateLayout() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.layoutIfNeeded()
            self.layoutDelegate?.didUpdateLayout()
        }
    }
    
    @objc
    private func tapButton() {
        guard let model = model as? ButtonCellModel else {
            return
        }
        model.action?()
    }
    
    
    @objc private
    func tapBegin(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 0.7
        })
    }
    
    @objc private
    func tapEnd(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 1
        })
    }

}
