//
//  FoodSearchController.swift
//  Loop
//
//  Created by Nikita Zaremba on 20.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit
import SnapKit

protocol FoodSearchViewControllerDelegate: AnyObject {
    func selectFood(product: FoodCoreData)
}

class FoodSearchViewController: SearchTableViewController {
    private var dataFood = [FoodCoreData]() {
        didSet {
            let models = dataFood.map({ food -> LableCellModel in
                let model = LableCellModel(font: .systemFont(ofSize: 18, weight: .regular), textColor: .white, numberOfLines: 0, insets: UIEdgeInsets(top: 18, left: 18, bottom: 20, right: 20), type: .text, alignment: .left)
                
                let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left
                paragraphStyle.lineSpacing = 3
                
                let attrString = NSMutableAttributedString(string: food.name ?? "", attributes: [.paragraphStyle: paragraphStyle])
                
                if let brand = food.brand?.name {
                    attrString.append(NSAttributedString(string: " " + brand, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor: UIColor.systemBlue]))
                }
                
                if let unit = food.units?.firstObject as? UnitCoreData,
                   var name = unit.name {
                    
                    var carb = unit.carb
                    var fat = unit.fat
                    var cal = unit.cal
                    var protein = unit.protein
                    if name.lowercased() == "г" {
                        name = "100г"
                        carb = carb * 100
                        fat = fat * 100
                        cal = cal * 100
                        protein = protein * 100
                    }
                    
                    
                    attrString.append(NSAttributedString(string: "\n" + name + ":\n", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .paragraphStyle: paragraphStyle]))
                    attrString.append(NSAttributedString(string: "уг: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor: UIColor.systemBlue, .paragraphStyle: paragraphStyle]))
                                      
                    attrString.append(NSAttributedString(string: carb.clean + "г,", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold), .paragraphStyle: paragraphStyle]))
                    
                    attrString.append(NSAttributedString(string:  " б: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor: UIColor.systemBlue]))
                    attrString.append(NSAttributedString(string: protein.clean + "г,", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
                    
                    attrString.append(NSAttributedString(string:  " ж: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor: UIColor.systemBlue]))
                    attrString.append(NSAttributedString(string: fat.clean + "г,", attributes:  [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
                    
                    attrString.append(NSAttributedString(string: " ккал: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor: UIColor.systemBlue]))
                    attrString.append(NSAttributedString(string: cal.clean , attributes:  [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
                    
                }
               
                
                
                model.attributedString = attrString
                return model
            })
            sectionModel = models
            
            tableView.reloadData()
        }
    }
    private var sectionModel = [TableCellModel]()
    var searchTimer: Timer?
    
    private lazy var selectBrandButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(title: "Filter brand",
                                      style: .plain,
                                      target: self,
                                      action: #selector(selectBrandVc))
        
        return button
    }()
    
    override var sections: [TableSectionModel] {
        let section = TableSectionModel()
        section.items = sectionModel
        return [section]
    }
    
    weak var delegate: FoodSearchViewControllerDelegate?
    
    private var selectedBrand: BrandFoodCoreData? {
        didSet {
            selectBrandButton.title = selectedBrand == nil ? "Filter brand" : "Filter brand ✅"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = selectBrandButton
        textField.addTarget(self, action: #selector(changeSearchText), for: [.editingChanged, .valueChanged])
    }
    
    @objc
    private func selectBrandVc() {
        let vc = BrandSearchViewController()
        vc.delegate = self
        show(vc, sender: selectBrandButton)
    }
    
    @objc
    private func changeSearchText() {
        self.searchTimer?.invalidate()
        let searchText = textField.text ?? ""
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.main.async {
                self?.showLoader(true)
            }
            
          DispatchQueue.global(qos: .userInteractive).async { [weak self] in
              FoodManagerCoreData.shared.findProduct(name: searchText.lowercased(),
                                                     brand: self?.selectedBrand) { models in
                  DispatchQueue.main.async {
                      self?.dataFood = models
                      self?.showLoader(false)
                  }
              }
          }
        })
    }
    
}


extension FoodSearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataFood[indexPath.item]
        delegate?.selectFood(product: model)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}


extension FoodSearchViewController: BrandSearchViewControllerDelegate {
    func selectBrand(brand: BrandFoodCoreData?) {
        self.selectedBrand = brand
        self.textField.text = ""
        self.changeSearchText()
    }
}
