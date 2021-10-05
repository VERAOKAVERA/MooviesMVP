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
    weak var view: MainViewProtocol?
    var films: Film
    init(view: MainViewProtocol, model: Film) {
        self.view = view
        films = model
    }

    func getMoviesOfType(_ type: MoviesType) {
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        view?.reloadTable()
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/\(type.urlPath)?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let usageData = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    self.films.results += pageMovies.results
                    DispatchQueue.main.async {
                        self.view?.reloadTable()
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }
}
