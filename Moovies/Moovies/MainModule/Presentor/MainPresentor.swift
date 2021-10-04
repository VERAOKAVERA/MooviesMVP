// MainPresentor.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {}

protocol MainViewPresentorProtocol: AnyObject {
    init(view: MainViewProtocol, moovieModel: Film)
    func getTopRatedRequest(moovies: Film, tableView: UITableView, title: String)
}

class MainPresentor: MainViewPresentorProtocol {
    func getTopRatedRequest(moovies: Film, tableView: UITableView, title: String = "") {
        var title = "Топ-100 за все время"
        var moovies = Film(results: [], totalResults: 0, totalPages: 0, page: 0)
        for page in 1 ... 5 {
            guard let url =
                URL(
                    string: "https://api.themoviedb.org/3/movie/top_rated?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU&page=\(page)"
                )
            else { return }

            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let usageData = data,
                      let usageResponse = response as? HTTPURLResponse else { return }
                print("status code: \(usageResponse.statusCode)")

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pageMovies = try decoder.decode(Film.self, from: usageData)
                    if moovies.results != nil {
                        moovies.results += pageMovies.results
                    } else {
                        moovies = pageMovies
                    }
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
    }

    var view: MainViewProtocol
    var moovieModel: Film

    required init(view: MainViewProtocol, moovieModel: Film) {
        self.view = view
        self.moovieModel = moovieModel
    }
}
