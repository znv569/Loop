//
//  FoodEntryCell.swift
//  Loop
//
//  Created by Nikita Zaremba on 18.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
 
@objc protocol FoodEntryCellDelegate: AnyObject {
    @objc optional func updateFoodEntrys()
}

class FoodEntryCell: TableCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    

    
    private let selectedUnitLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    
    private lazy var unitStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        let container = UIView()
        container.addSubview(countLabel)
        
         [container, selectedUnitLabel].forEach { stack.addArrangedSubview($0) }
         return stack
     }()
    
    
    private let unitsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var detailStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        [unitStack, unitsLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var countTextField: UITextField = {
       let tf = UITextField()
        tf.delegate = self
        tf.textAlignment = .center
        tf.textColor = .white
        tf.keyboardType = .decimalPad
        tf.addTarget(self, action: #selector(changeValueCount), for: [.valueChanged, .editingChanged])
        return tf
    }()
    
    private lazy var pickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var editStack: UIStackView = {
        let stack = UIStackView()
         stack.axis = .vertical
        stack.spacing = 8
        let container = UIView()
        container.addSubview(countTextField)
         [pickerView, container].forEach { stack.addArrangedSubview($0) }
         return stack
     }()
    
    private lazy var mainStackStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        [nameLabel, detailStack].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    
    weak var delegate: FoodEntryCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupView() {
        contentView.addSubview(mainStackStack)
        
        countLabel.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
        }
        
        mainStackStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        countTextField.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.centerY.leading.trailing.equalToSuperview()
        }
    }
    
    override func updateViews() {
        guard let model = model as? FoodEntryCellModel else { return }
        
        model.startEditing = { [weak self] in
            self?.countTextField.becomeFirstResponder()
        }
        
        model.updateView = { [weak self] in
            self?.updateViews()
        }
        model.updateMode = { [weak self] in
            self?.updateMode()
        }
        
        updateMode()
        updateModel()
        pickerView.reloadAllComponents()
    }
    
    @objc
    private func changeValueCount() {
        guard let model = model as? FoodEntryCellModel else { return }
        if let text = countTextField.text,
           text.last != ".",
           let count = Double(text) {
            model.count = count
        }
    }
    
    private func updateModel() {
        guard let model = model as? FoodEntryCellModel else { return }
        let nameAttr = NSMutableAttributedString(string: model.food.name ?? "", attributes: nil)
        if let brand = model.food.brand?.name {
            nameAttr.append(NSAttributedString(string: "\n" + brand, attributes: [.font: UIFont.systemFont(ofSize: 19, weight: .semibold), .foregroundColor: UIColor.systemBlue]))
        }
        
        nameLabel.attributedText = nameAttr
        countLabel.text = model.count.clean
        selectedUnitLabel.text = model.selectedUnit?.name
        countTextField.text = model.count.clean
        
        if let selectedUnit = model.selectedUnit {
            let attString = NSMutableAttributedString(string: "уг: ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.systemBlue])
            attString.append(NSAttributedString(string: (model.count * selectedUnit.carb).clean + "г", attributes: nil))
            
            attString.append(NSAttributedString(string:  ", б: ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.protein).clean + "г", attributes: nil))
            
            attString.append(NSAttributedString(string:  ", ж: ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.fat).clean + "г", attributes: nil))
            
            attString.append(NSAttributedString(string: ", ккал: ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.cal).clean , attributes: nil))
            
            unitsLabel.attributedText = attString
            
            if let index = model.food.units?.index(of: selectedUnit) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    private func updateMode() {
        guard let model = model as? FoodEntryCellModel else { return }
        switch model.mode {
        case .full:
            UIView.animate(withDuration: 0.2) {
                self.detailStack.isHidden = true
                self.mainStackStack.layoutSubviews()
                self.layoutDelegate?.didUpdateLayout()
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.editStack.isHidden = false
                    self.mainStackStack.layoutSubviews()
                    self.layoutDelegate?.didUpdateLayout()
                }
            }
        case .short:
            UIView.animate(withDuration: 0.2) {
                self.editStack.isHidden = true
                self.mainStackStack.layoutSubviews()
                self.layoutDelegate?.didUpdateLayout()
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.detailStack.isHidden = false
                    self.mainStackStack.layoutSubviews()
                    self.layoutDelegate?.didUpdateLayout()
                }
            }
        }
    }
    
    
}


extension FoodEntryCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === self.countTextField,
           string == ",",
           let text = textField.text  {
            textField.text = text + "."
            return false
        }
        return true
    }
}

extension FoodEntryCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let model = model as? FoodEntryCellModel else { return UIView() }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width - 30, height: 90))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = (model.food.units?[row] as? UnitCoreData)?.name
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let model = model as? FoodEntryCellModel,
              let unit = model.food.units?[row] as? UnitCoreData
        else { return }
        model.selectedUnit = unit
    }
}

extension FoodEntryCell: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (model as? FoodEntryCellModel)?.food.units?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
