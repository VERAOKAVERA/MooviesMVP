// AssemblyProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol AssemblyProtocol: AnyObject {
    func buildMain(router: RouterProtocol) -> UIViewController
    func buildDetail(film: Movie?, id: Int, router: RouterProtocol) -> UIViewController
}

final class MoviewModules: AssemblyProtocol {
    func buildMain(router: RouterProtocol) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let view = MooviesViewController()
        let dataStorageService = DataStorageService()
        let presenter = MainPresentor(
            view: view,
            service: movieAPIService,
            router: router,
            coreDataService: dataStorageService
        )
        view.presentor = presenter
        return view
    }

    func buildDetail(film: Movie?, id: Int, router: RouterProtocol) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let view = MoovieDescriptionTableViewController()
        let dataStorageService = DetailsDataStorageService()
        let presenter = DescriptionPresentor(
            view: view,
            id: id,
            service: movieAPIService,
            router: router, dataStorageService: dataStorageService
        )
        view.presentor = presenter
        return view
    }
}
