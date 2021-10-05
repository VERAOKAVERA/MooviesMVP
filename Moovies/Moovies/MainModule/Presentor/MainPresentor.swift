// MainPresentor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

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

protocol MainViewPresentorProtocol: AnyObject {
    var films: Film { get }
    func getMoviesOfType(_ type: MoviesType)
}

class MainPresentor: MainViewPresentorProtocol {
    private var movieAPIservice: MovieAPIServiceProtocol
    weak var view: MainViewProtocol?
    var films: Film
    init(view: MainViewProtocol, model: Film, service: MovieAPIServiceProtocol) {
        self.view = view
        films = model
        movieAPIservice = service
    }

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
//        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
//        view?.reloadTable()
//
//            guard let url =
//                URL(
//                    string: "https://api.themoviedb.org/3/movie/\(type.urlPath)?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=1"
//                )
//            else { return }
//
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                guard let usageData = data else { return }
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let pageMovies = try decoder.decode(Film.self, from: usageData)
//                    self.films.results += pageMovies.results
//                    DispatchQueue.main.async {
//                        self.view?.reloadTable()
//                    }
//                } catch {
//                    print("Error")
//                }
//            }.resume()
}
