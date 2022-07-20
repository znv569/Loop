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
 
protocol FoodEntryCellDelegate: AnyObject {
    func updateFoodEntrys()
    func deleteCell(model: FoodEntryCellModel)
}

class FoodEntryCell: TableCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    private let arrowImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.down")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var nameArrowStack: UIStackView = {
       let stack = UIStackView()
        stack.spacing = 8
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(arrowImageView)
        return stack
    }()
    
    private let selectedUnitLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.invalid
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteModel), for: .touchUpInside)
        return button
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var detailStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        [unitStack].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var countTextField: UITextField = {
       let tf = UITextField()
        tf.delegate = self
        tf.textAlignment = .center
        tf.textColor = .white
        tf.keyboardType = .decimalPad
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 18, weight: .semibold)
        tf.addTarget(self, action: #selector(changeValueCount), for: [.valueChanged, .editingChanged])
        return tf
    }()
    
    private lazy var pickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var editUnitStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        let container = UIView()
        container.addSubview(countTextField)
        let containerPicker = UIView()
        containerPicker.layer.masksToBounds = true
        containerPicker.addSubview(pickerView)
        
         [containerPicker, container].forEach { stack.addArrangedSubview($0) }
         return stack
     }()
    
    private lazy var editStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
         [unitsLabel, editUnitStack].forEach { stack.addArrangedSubview($0) }
         return stack
     }()
    
    private lazy var mainStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        [nameArrowStack, detailStack, editStack].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var mainStackDelete: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        let container = UIView()
        container.addSubview(mainStack)
        [deleteButton, container].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    
    weak var delegate: FoodEntryCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        contentView.addSubview(mainStackDelete)
        
        countLabel.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
        }
        
        mainStackDelete.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        countTextField.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.centerY.leading.trailing.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        pickerView.snp.makeConstraints {
            $0.leading.centerY.trailing.equalToSuperview()
        }
        pickerView.superview?.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        contentView.backgroundColor = .cellBackgroundColor
    }
    
    override func updateViews() {
        guard let model = model as? FoodEntryCellModel else { return }
        
        model.startEditing = { [weak self] in
            self?.countTextField.becomeFirstResponder()
        }
        
        model.updateView = { [weak self] in
            self?.updateModel(updateLayout: true)
        }
        model.updateMode = { [weak self] in
            self?.updateMode()
        }
        
        self.detailStack.isHidden = model.mode == .full
        self.editStack.isHidden =  model.mode == .short
        self.deleteButton.isHidden =  model.mode == .short
        self.arrowImageView.transform = model.mode == .full ? CGAffineTransform(rotationAngle: .pi) : .identity
            
        updateModel(updateLayout: false)
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
    
    private func updateModel(updateLayout: Bool) {
        guard let model = model as? FoodEntryCellModel else { return }
        let nameAttr = NSMutableAttributedString(string: model.food.name ?? "", attributes: nil)
        if let brand = model.food.brand?.name {
            nameAttr.append(NSAttributedString(string: " " + brand, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor: UIColor.systemBlue]))
        }
        
        nameLabel.attributedText = nameAttr
        countLabel.text = model.count.clean + " x"
        selectedUnitLabel.text = model.selectedUnit?.name
        countTextField.text = model.count.clean
        
        if let selectedUnit = model.selectedUnit {
            let attString = NSMutableAttributedString(string: "уг: ", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.systemBlue])
            attString.append(NSAttributedString(string: (model.count * selectedUnit.carb).clean + "г,", attributes: nil))
            
            attString.append(NSAttributedString(string:  " б: ", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.protein).clean + "г,", attributes: nil))
            
            attString.append(NSAttributedString(string:  " ж: ", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.fat).clean + "г,", attributes: nil))
            
            attString.append(NSAttributedString(string: " ккал: ", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.systemBlue]))
            attString.append(NSAttributedString(string: (model.count * selectedUnit.cal).clean , attributes: nil))
            
            unitsLabel.attributedText = attString
            
            if let index = model.food.units?.index(of: selectedUnit),
                index != pickerView.selectedRow(inComponent: 0) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        if updateLayout {
            self.delegate?.updateFoodEntrys()
            UIView.animate(withDuration: 0.2) {
                self.mainStack.layoutIfNeeded()
                self.layoutDelegate?.didUpdateLayout()
            }
        }
    }
    
    private func updateMode() {
        guard let model = model as? FoodEntryCellModel else { return }
        switch model.mode {
        case .full:
            UIView.animate(withDuration: 0.2) {
                self.detailStack.isHidden = true
                self.mainStackDelete.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.editStack.isHidden = false
                    self.deleteButton.isHidden = false
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
                    self.mainStack.snp.updateConstraints {
                        $0.trailing.leading.equalToSuperview().inset(3)
                    }
                    self.mainStack.layoutIfNeeded()
                    self.mainStackDelete.layoutIfNeeded()
                    self.layoutDelegate?.didUpdateLayout()
                }
            }
        case .short:
            UIView.animate(withDuration: 0.2) {
                self.editStack.isHidden = true
                self.deleteButton.isHidden = true
                self.mainStackDelete.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.detailStack.isHidden = false
                    self.arrowImageView.transform = .identity
                    self.mainStack.snp.updateConstraints {
                        $0.trailing.leading.equalToSuperview().inset(20)
                    }
                    self.mainStack.layoutIfNeeded()
                    self.mainStackDelete.layoutIfNeeded()
                    self.layoutDelegate?.didUpdateLayout()
                }
            }
        }
    }
    
    
    @objc
    private func deleteModel() {
        guard let model = model as? FoodEntryCellModel else { return }
        self.delegate?.deleteCell(model: model)
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width - 10, height: 90))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
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
