//
//  AddFoodCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 06.08.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit
import SnapKit

class TextFieldCell: TableCell {
    enum FieldType: String {
        case name
        case carb
        case fat
        case protein
        case cal
    }
    
    private func makeField(labelName: String, type: FieldType) -> UIStackView {
        let stack = UIStackView()
        
        let textField = UITextField()
        textField.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        textField.accessibilityIdentifier = type.rawValue
        switch type {
        case .name:
            textField.keyboardType = .default
        case .carb, .fat, .protein, .cal:
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        
        let label = UILabel()
        
        [label, textField].forEach({ stack.addArrangedSubview($0) })
        
        return stack
    }
    
    @objc
    private func changeValue(_ sender: UITextField) {
        switch FieldType(rawValue: sender.accessibilityIdentifier ?? "") {
        case .name:
            
        case .carb:
            
        case .fat:
            
        case .protein:
            
        case .cal:
            
        case .none:
            
        }
    }
    
    
}

extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ",",
           let text = textField.text  {
            textField.text = text + "."
            return false
        }
        return true
    }
}
