//
//  TabBarViewController.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 29.05.24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    //MARK: - Variables
    private let viewModel: TabBarVCViewModelProtocol = TabBarVCViewModel()

    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    //MARK: - Methods
    private func setUpTabBar() {
        let configuredTabBar = viewModel.configureTabBarController()
        viewControllers = configuredTabBar.viewControllers
        tabBar.backgroundColor = configuredTabBar.tabBar.backgroundColor
    }

}
