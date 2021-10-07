// AssemblyProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol AssemblyProtocol: AnyObject {
    func buildMain(router: RouterProtocol) -> UIViewController
    func buildDetail(film: Results?, id: Int, router: RouterProtocol) -> UIViewController
}

final class MoviewModules: AssemblyProtocol {
    func buildMain(router: RouterProtocol) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let view = MooviesViewController()
        let films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        let presenter = MainPresentor(view: view, model: films, service: movieAPIService, router: router)
        view.presentor = presenter
        return view
    }

    func buildDetail(film: Results?, id: Int, router: RouterProtocol) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let view = MoovieDescriptionTableViewController()
        let description = Description(posterPath: "", title: "", overview: "")
        let presenter = DescriptionPresentor(
            view: view,
            model: description,
            id: id,
            service: movieAPIService,
            router: router
        )
        view.presentor = presenter
        return view
    }
}