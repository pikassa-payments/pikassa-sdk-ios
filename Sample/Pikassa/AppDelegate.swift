//
//  AppDelegate.swift
//  PIMPAY KASSA LLC, support@pikassa.io
//
//  Created by pikassa on 29.06.2020.
//

import UIKit
import PikassaSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Pikassa.setup(apiKey: "be4d9881-4af5-4969-bac0-dfe8491a333a")

        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

