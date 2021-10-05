// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let mainVC = ModulesBuilder.buildMain()
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
//        let vc = MooviesViewController()
//        let films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
//        let presenter = MainPresentor(view: vc, model: films)
//        vc.presentor = presenter
//        let navigationController = UINavigationController(rootViewController: vc)
//        window?.rootViewController = navigationController
//        navigationController.navigationBar.backgroundColor = .systemPink
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
