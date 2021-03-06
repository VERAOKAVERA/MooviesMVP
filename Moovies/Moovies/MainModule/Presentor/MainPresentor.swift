// MainPresentor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

// MARK: - Enum MoviesType

enum MoviesType: Int {
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
    var films: MoviesResult { get }
    func getMoviesOfType(_ type: MoviesType)
    func openMoovieDescription(film: Movie)
}

// MARK: - MainPresentor

class MainPresentor: MainViewPresentorProtocol {
    // MARK: - Internal Properties

    var films = MoviesResult(results: [], totalResults: 0, totalPages: 0, page: 0)
    var router: RouterProtocol
    private var dataStorageService: DataStorageService

    // MARK: - Private Properties

    private var movieAPIService: MovieAPIServiceProtocol
    private weak var view: MainViewProtocol?

    init(
        view: MainViewProtocol,
        service: MovieAPIServiceProtocol,
        router: RouterProtocol,
        coreDataService: DataStorageService
    ) {
        self.view = view
        movieAPIService = service
        self.router = router
        dataStorageService = coreDataService
    }

    // MARK: - Public func

    func getMoviesOfType(_ type: MoviesType) {
        let existingMovies = dataStorageService.get(movieType: type)

        if !existingMovies.isEmpty {
            films.results = existingMovies
            view?.reloadTable()
            return
        }
        films = MoviesResult(results: [], totalResults: 0, totalPages: 0, page: 0)
        view?.reloadTable()

        movieAPIService.getMoviesOfTypeService(type.urlPath) { [weak self] result in
            switch result {
            case let .failure(error):
                print("APIService error! \(error)")
            case let .success(filmsResults):
                DispatchQueue.main.async {
                    self?.films.results = filmsResults
                    self?.dataStorageService.save(object: filmsResults, movieType: type)
                    self?.view?.reloadTable()
                }
            }
        }
    }

    func openMoovieDescription(film: Movie) {
        router.showDetails(films: film, id: film.id)
    }
}
