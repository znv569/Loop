//
//  AddFoodCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 06.08.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit
import SnapKit

class AddFoodCell: TableCell {
    enum FieldType: String, CaseIterable {
        case name
        case carb
        case fat
        case protein
        case cal
    }
    
    private var textFields: [String: UITextField] = [:]
    
    private lazy var labelUnit: UILabel = {
        let label = UILabel()
        label.text = "New unit"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override func setupView() {
        for type in FieldType.allCases {
            let stack = makeField(type: type)
            mainStack.addArrangedSubview(stack)
        }
    }
    
    
    override func updateConstraints() {
        
    }
    
    override func updateViews() {
        guard let model = model as? AddFoodCellModel else { return }
        for fieldType in FieldType.allCases {
            switch fieldType {
            case .name:
                textFields[fieldType.rawValue]?.text = model.name
            case .carb:
                textFields[fieldType.rawValue]?.text = String(model.carb)
            case .fat:
                textFields[fieldType.rawValue]?.text = String(model.fat)
            case .protein:
                textFields[fieldType.rawValue]?.text = String(model.protein)
            case .cal:
                textFields[fieldType.rawValue]?.text = String(model.cal)
            }
        }
    }
    
    private func makeField(type: FieldType) -> UIStackView {
        let stack = UIStackView()
        
        let textField = UITextField()
        textField.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        textField.accessibilityIdentifier = type.rawValue
        
        switch type {
        case .name:
            textField.keyboardType = .default
            textField.delegate = nil
        case .carb, .fat, .protein, .cal:
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }

        
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .axisLabelColor
        
        switch type {
        case .name:
            label.text = "Unit name"
        case .carb:
            label.text = "Carb"
        case .fat:
            label.text = "Fat"
        case .protein:
            label.text = "Protein"
        case .cal:
            label.text = "Cal"
        }
        
        let container = UIView()
        container.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(25)
            $0.width.equalTo(100)
        }
        container.setContentHuggingPriority(.required, for: .horizontal)
        
        self.textFields[type.rawValue] = textField
        
        [label, container].forEach({ stack.addArrangedSubview($0) })
        
        return stack
    }
    
    @objc
    private func changeValue(_ sender: UITextField) {
        guard let model = model as? AddFoodCellModel else { return }
        
        switch FieldType(rawValue: sender.accessibilityIdentifier ?? "") {
        case .name:
            model.name = sender.text ?? ""
        case .carb:
            model.carb = Double(sender.text ?? "") ?? 0
        case .fat:
            model.fat = Double(sender.text ?? "") ?? 0
        case .protein:
            model.protein = Double(sender.text ?? "") ?? 0
        case .cal:
            model.cal = Double(sender.text ?? "") ?? 0
        case .none:
            break
        }
    }
    
    
}

extension AddFoodCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ",",
           let text = textField.text  {
            textField.text = text + "."
            return false
        }
        return true
    }
}
