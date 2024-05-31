//
//  TabBarVCViewModel.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 31.05.24.
//

import Foundation
import UIKit

protocol TabBarVCViewModelProtocol {
    func configureTabBarController() -> UITabBarController
}

final class TabBarVCViewModel: TabBarVCViewModelProtocol {
    func configureTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = CustomColors.darkBlue
        
        let titleTab1 = "Editor"
        let titleTab2 = "Settings"
        
        let tab1 = EditorViewController()
        tab1.title = titleTab1
        let tab2 = SettingsViewController()
        tab2.title = titleTab2
        
        let navigation1 = UINavigationController(rootViewController: tab1)
        let navigation2 = UINavigationController(rootViewController: tab2)
        
        navigation1.tabBarItem = UITabBarItem(title: titleTab1, image: UIImage(systemName: "crop.rotate"), tag: 1)
        navigation2.tabBarItem = UITabBarItem(title: titleTab2, image: UIImage(systemName: "gearshape"), tag: 2)
        
        tabBar.setViewControllers([navigation1, navigation2], animated: true)
        
        return tabBar
    }
}
