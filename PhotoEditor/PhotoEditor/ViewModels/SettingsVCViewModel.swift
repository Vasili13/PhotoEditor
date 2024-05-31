//
//  SettingsVCViewModel.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 31.05.24.
//

import Foundation

protocol SettingsVCViewModelProtocol {
    var tableInfoList: [TableModel] { get }
    func saveUser(firstName: String, lastName: String)
    func heightForRow() -> CGFloat
}

final class SettingsVCViewModel: SettingsVCViewModelProtocol {
    
    var tableInfoList: [TableModel] = [TableModel(iconText: "info.circle",
                                                  titleText: "Об приложении")]
    
    func saveUser(firstName: String, lastName: String) {
        let fullName = "\(firstName) \(lastName)"
        print("Full Name: \(fullName)")
    }
    
    func heightForRow() -> CGFloat {
        return 70
    }
}
