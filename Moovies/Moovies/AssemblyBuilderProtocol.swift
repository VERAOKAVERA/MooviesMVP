// AssemblyBuilderProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func buildMain(router: RouterProtocol) -> UIViewController
    func buildDetail(film: Results?, id: Int, router: RouterProtocol) -> UIViewController
}

final class ModulesBuilder: AssemblyBuilderProtocol {
    func buildMain(router: RouterProtocol) -> UIViewController {
        let service = MovieAPIService()
        let view = MooviesViewController()
        let films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        let presenter = MainPresentor(view: view, model: films, service: service, router: router)
        view.presentor = presenter
        return view
    }

    func buildDetail(film: Results?, id: Int, router: RouterProtocol) -> UIViewController {
        let service = MovieAPIService()
        let view = MoovieDescriptionTableViewController()
        let description = Description(posterPath: "", title: "", overview: "")
        let presenter = DescriptionPresentor(view: view, model: description, id: id, service: service, router: router)
        view.presentor = presenter
        return view
    }
}
