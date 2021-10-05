// Builder.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol Builder {
    static func buildMain() -> UIViewController
    static func buildDetail(film: Result?, id: Int) -> UIViewController
}

final class ModulesBuilder: Builder {
    static func buildMain() -> UIViewController {
        // let service = MovieAPIService()
        let view = MooviesViewController()
        let films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        let presenter = MainPresentor(view: view, model: films)
        view.presentor = presenter
        return view
    }

    static func buildDetail(film: Result?, id: Int) -> UIViewController {
        // let service = MovieAPIService()
        let view = MoovieDescriptionTableViewController()
        let description = Description(posterPath: "", title: "", overview: "")
//        let id = Result(posterPath: "", overview: "", title: "", releaseDate: "", id: 0, voteAverage: 0)
        let presenter = DescriptionPresentor(view: view, model: description, id: id)
        view.presentor = presenter
        return view
    }
}
