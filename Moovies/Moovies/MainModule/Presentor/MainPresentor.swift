// MainPresentor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

// MARK: - Enum MoviesType
enum MoviesType {
    case topRated
    case popular
    case upcoming

    var urlPath: String {
        switch self {
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        }
    }
}

    // MARK: - MainViewPresentorProtocol
protocol MainViewPresentorProtocol: AnyObject {
    var films: Film { get }
    func getMoviesOfType(_ type: MoviesType)
}

    // MARK: - MainPresentor
class MainPresentor: MainViewPresentorProtocol {

    // MARK: - Private Properties
    private var movieAPIservice: MovieAPIServiceProtocol
    weak var view: MainViewProtocol?
    var films: Film
    init(view: MainViewProtocol, model: Film, service: MovieAPIServiceProtocol) {
        self.view = view
        films = model
        movieAPIservice = service
    }

    // MARK: - Public func 
    func getMoviesOfType(_ type: MoviesType) {
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        view?.reloadTable()
        movieAPIservice.getMoviesOfTypeService(type.urlPath) { [weak self] result in
            switch result {
            case let .failure(error):
                print("APIService error! \(error)")
            case let .success(filmsResults):
                self?.films.results = filmsResults
                DispatchQueue.main.async {
                    self?.view?.reloadTable()
                }
            }
        }
    }
}
