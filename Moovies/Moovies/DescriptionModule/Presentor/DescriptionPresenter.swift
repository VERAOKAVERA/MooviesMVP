// DescriptionPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol DescriptionViewProtocol: AnyObject {
    func reloadTable()
}

protocol DescriptionViewPresentorProtocol: AnyObject {
    var details: Description { get }
    var ide: Int { get }
    func getMoovieDescription()
}

class DescriptionPresentor: DescriptionViewPresentorProtocol {
    var details = Description(posterPath: "", title: "", overview: "")
    var ide: Int
    var router: RouterProtocol?
    var dataStorageService: DetailsDataStorageService

    private var movieAPIservice: MovieAPIServiceProtocol
    private weak var view: DescriptionViewProtocol?

    init(
        view: DescriptionViewProtocol,
        id: Int,
        service: MovieAPIService,
        router: RouterProtocol,
        dataStorageService: DetailsDataStorageService
    ) {
        self.view = view
        self.router = router
        ide = id
        movieAPIservice = service
        self.dataStorageService = dataStorageService
    }

    func getMoovieDescription() {
        let existingMovies = dataStorageService.getDescription(id: ide)

        if !existingMovies.isEmpty {
            details = existingMovies[0]
            view?.reloadTable()
            return
        }
        movieAPIservice.getMovieDescriptionService(id: ide) { [weak self] result in
            switch result {
            case let .failure(error):
                print("APIService error! \(error)")
            case let .success(filmsResults):
                self?.details = filmsResults
                DispatchQueue.main.async {
                    self?.details = filmsResults
                    self?.dataStorageService.saveDescription(object: [filmsResults], id: self?.ide ?? 0)
                    self?.view?.reloadTable()
                }
            }
        }
    }
}
