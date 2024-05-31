//
//  SceneDelegate.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 29.05.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = TabBarViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

