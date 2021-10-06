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

    private var movieAPIservice: MovieAPIServiceProtocol
    private weak var view: DescriptionViewProtocol?

    init(view: DescriptionViewProtocol, model: Description, id: Int, service: MovieAPIService, router: RouterProtocol) {
        self.view = view
        details = model
        self.router = router
        ide = id
        movieAPIservice = service
    }

    func getMoovieDescription() {
        movieAPIservice.getMovieDescriptionService(id: ide) { [weak self] result in
            switch result {
            case let .failure(error):
                print("APIService error! \(error)")
            case let .success(filmsResults):
                self?.details = filmsResults
                DispatchQueue.main.async {
                    self?.view?.reloadTable()
                }
            }
        }
    }
}
