// MainPresentor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

protocol MainViewPresentorProtocol: AnyObject {
    init(view: MainViewProtocol, model: Film)
    func getTopRatedRequest()
//    func getPopularRequest()
//    func getUpcomingRequest()
}

class MainPresentor: MainViewPresentorProtocol {
    var view: MainViewProtocol
    var films: Film
    required init(view: MainViewProtocol, model: Film) {
        self.view = view
        films = model
    }

    func getTopRatedRequest() {
        films = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/top_rated?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let usageData = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    self.films.results += pageMovies.results

//                    DispatchQueue.main.async {
//                        self.view.reloadTable()
//                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }
}
