//
//  SceneDelegate.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 29.06.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else {
            return
        }

        self.window = UIWindow(windowScene: windowScene)

        let navigationController: UINavigationController = UINavigationController(rootViewController: QuantityViewController())
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

