//
//  CustomTableViewController.swift
//  Loop
//
//  Created by Nikita Zaremba on 20.07.2022.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import UIKit
import SnapKit

class SearchTableViewController: UIViewController {

    var sections: [TableSectionModel] {
        []
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Input prodct name"
        textField.font = .systemFont(ofSize: 19, weight: .regular)
        textField.addTarget(self, action: #selector(textChange), for: [.editingChanged, .valueChanged])
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var clearButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(tapDelete), for: .touchUpInside)
        button.isHidden = true
        button.tintColor = .secondaryLabel
        button.contentMode = .center
        return button
    }()
    
    var lastOffset: CGFloat = 0
    
    private var keyboardShowed = false
    
    deinit{
        print("deinit searchController")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
        configureTable()
        configureKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupStyle()
    }
    
    private func setupStyle() {
        textField.textColor = .secondaryLabel
    }
    
    private func configureKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kbDidShow(notification: Notification) {
        keyboardShowed = true
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(kbFrameSize.height)
            }
            self?.view.layoutIfNeeded()
        }
    }

    @objc func kbDidHide() {
        keyboardShowed = false
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(18)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func configureTable() {
        tableView.register(LabelCell.self, forCellReuseIdentifier: LabelCell.className)
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .clear
    }
    
    @objc
    private func tapContainer() {
        textField.becomeFirstResponder()
    }
    
    private func makeConstraints() {
        let container = UIView()
        container.addSubview(textField)
        container.layer.cornerRadius = 8
        container.layer.borderColor = UIColor.cellBackgroundColor.cgColor
        container.layer.borderWidth = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapContainer))
        container.addGestureRecognizer(tap)
        container.addSubview(clearButton)
        
        view.addSubview(container)
        
        container.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(15)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(3)
            $0.bottom.equalToSuperview().inset(15)
            $0.top.equalTo(container.snp.bottom).offset(10)
        }
        clearButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
    }
    
    @objc
    private func textChange() {
        clearButton.isHidden = (textField.text?.count ?? 0) == 0
    }
    
    @objc
    private func tapDelete() {
        textField.text = nil
        clearButton.isHidden = (textField.text?.count ?? 0) == 0
    }
    
}


extension SearchTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 250 && lastOffset != offset {
            lastOffset = offset
            view.endEditing(true)
        }
    }
}


extension SearchTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].items[indexPath.item].cellIdentifier) as? TableCell else { return UITableViewCell() }
        
        cell.model = sections[indexPath.section].items[indexPath.item]
        return cell
    }
    
    
}
