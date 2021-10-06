// Builder.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol Builder {
    static func buildMain() -> UINavigationController
    static func buildDetail(film: Results?, id: Int) -> UIViewController
}

final class ModulesBuilder: Builder {
    static func buildMain() -> UINavigationController {
        let service = MovieAPIService()
        let view = MooviesViewController()
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.backgroundColor = .systemPink
        let films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        let presenter = MainPresentor(view: view, model: films, service: service)
        view.presentor = presenter
        return navigationController
    }

    static func buildDetail(film: Results?, id: Int) -> UIViewController {
        let service = MovieAPIService()

        let view = MoovieDescriptionTableViewController()
        let description = Description(posterPath: "", title: "", overview: "")
        let presenter = DescriptionPresentor(view: view, model: description, id: id, service: service)
        view.presentor = presenter
        return view
    }
}
