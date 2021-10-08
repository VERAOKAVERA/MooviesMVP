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
    var details: Description
    var ide: Int
    var router: RouterProtocol?
    var coreDataService: DetailsDataStorageService

    private var movieAPIservice: MovieAPIServiceProtocol
    private weak var view: DescriptionViewProtocol?

    init(
        view: DescriptionViewProtocol,
        model: Description,
        id: Int,
        service: MovieAPIService,
        router: RouterProtocol,
        coreDataService: DetailsDataStorageService
    ) {
        self.view = view
        details = model
        self.router = router
        ide = id
        movieAPIservice = service
        self.coreDataService = coreDataService
    }

    func getMoovieDescription() {
        let existingMovies = coreDataService.getDescription(id: ide)

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
                    self?.coreDataService.saveDescription(object: [filmsResults], id: self?.ide ?? 0)
                    self?.view?.reloadTable()
                }
            }
        }
    }
}
