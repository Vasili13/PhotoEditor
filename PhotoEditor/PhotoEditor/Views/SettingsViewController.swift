//
//  SettingsViewController.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 29.05.24.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    //MARK: - Variables
    private var viewModel: SettingsVCViewModelProtocol = SettingsVCViewModel()
    
    private var settingsList: [TableModel] = []
    
    private var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.key)
        tableView.backgroundColor = CustomColors.lightBlue
        return tableView
    }()

    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpDelegates()
    }
    
    //MARK: - Methods
    private func setUpUI() {
        settingsList = viewModel.tableInfoList
        view.backgroundColor = CustomColors.lightBlue
        view.addSubview(settingsTableView)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CustomColors.lightBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    private func setUpDelegates() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Привет!", message: "Введите свое имя и фамилию", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Фамилия"
        }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let firstName = alert.textFields?[0].text, let lastName = alert.textFields?[1].text else { return }
            self?.viewModel.saveUser(firstName: firstName, lastName: lastName)
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Contraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

//MARK: - Extension TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.key, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.setUpCell(withModel: settingsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
}
