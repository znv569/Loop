//
//  BrandSearchViewController.swift
//  Loop
//
//  Created by Nikita Zaremba on 20.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit
import SnapKit

protocol BrandSearchViewControllerDelegate: AnyObject {
    func selectBrand(brand: BrandFoodCoreData?)
}

class BrandSearchViewController: SearchTableViewController {
    
    private var dataBrand = [BrandFoodCoreData]() {
        didSet {
            let models = dataBrand.map({ brand -> LableCellModel in
                let model = LableCellModel(font: .systemFont(ofSize: 18, weight: .regular), textColor: .white, numberOfLines: 0, insets: UIEdgeInsets(top: 18, left: 18, bottom: 20, right: 20), type: .text, alignment: .left)
                let attrString = NSMutableAttributedString(string: brand.name ?? "", attributes: nil)
                
                model.attributedString = attrString
                return model
            })
            sectionModel = models
            
            tableView.reloadData()
        }
    }
    
    private lazy var skipFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear brand", style: .plain, target: self, action: #selector(deselectBrand))
        return button
    }()
    
    private var sectionModel = [TableCellModel]()
    var searchTimer: Timer?
    
    
    
    override var sections: [TableSectionModel] {
        let section = TableSectionModel()
        section.items = sectionModel
        return [section]
    }
    
    weak var delegate: BrandSearchViewControllerDelegate?
    
    private var selectedBrand: BrandFoodCoreData? {
        didSet {  }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        textField.addTarget(self, action: #selector(changeSearchText), for: [.editingChanged, .valueChanged])
        navigationItem.rightBarButtonItem = skipFilterButton
        textField.placeholder = "Input, brand, resturant, shop name"
    }
    
    @objc
    private func deselectBrand() {
        delegate?.selectBrand(brand: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func changeSearchText() {
        self.searchTimer?.invalidate()
        guard let searchText = textField.text?.lowercased() else { return }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.main.async {
                self?.showLoader(true)
            }
          DispatchQueue.global(qos: .userInteractive).async { [weak self] in
              BrandMangerCoreData.shared.findBrands(brand: searchText) { brands in
                  brands.forEach({  print("|\($0.name ?? "")|") })
                 
                  DispatchQueue.main.async {
                      self?.dataBrand = brands
                      self?.showLoader(false)
                  }
              }
          }
        })
    }
    
}


extension BrandSearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataBrand[indexPath.item]
        delegate?.selectBrand(brand: model)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}

