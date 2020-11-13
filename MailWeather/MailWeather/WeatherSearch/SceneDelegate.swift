//
//  SceneDelegate.swift
//  MailWeather
//
//  Created by Maxim on 13.11.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene

        let firstVC = WeatherSearchViewController()
        let router = WeatherSearchRouter(viewController: firstVC)
        firstVC.searchVM = WeatherSearchViewModel(router: router)

        let navigationVC = UINavigationController(rootViewController: firstVC)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }

}

