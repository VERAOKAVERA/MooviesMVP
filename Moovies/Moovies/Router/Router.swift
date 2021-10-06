// Router.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetails(films: Results?, id: Int)
    // func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let mainVC = assemblyBuilder?.buildMain(router: self) else { return }
        navigationController.viewControllers = [mainVC]
    }

    func showDetails(films: Results?, id: Int) {
        guard let navigationController = navigationController else { return }
        guard let detailVC = assemblyBuilder?.buildDetail(film: films, id: id, router: self) else { return }
        navigationController.pushViewController(detailVC, animated: true)
    }

//    func popToRoot() {
//        <#code#>
//    }
}
