// DescriptionPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol DescriptionViewProtocol: AnyObject {
    func reloadTable()
}

protocol DescriptionViewPresentorProtocol: AnyObject {
    var details: Description { get }
    func getMoovieDescription()
}

class DescriptionPresentor: DescriptionViewPresentorProtocol {
    weak var view: DescriptionViewProtocol?
    var details: Description
    var ide: Result
    init(view: DescriptionViewProtocol, model: Description, id: Result) {
        self.view = view
        details = model
        ide = id
    }

    func getMoovieDescription() {
        guard let url =
            URL(
                string: "https://api.themoviedb.org/3/movie/\(ide.id)?api_key=209be2942f86f39dd556564d2ad35c5c&language=ru-RU"
            )
        else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let usageData = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.details = try decoder.decode(Description.self, from: usageData)
                DispatchQueue.main.async {
                    self.view?.reloadTable()
                }
            } catch {
                print("Error detail request")
            }
        }.resume()
    }
}
