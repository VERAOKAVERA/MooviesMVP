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
    private var movieAPIservice: MovieAPIServiceProtocol
    weak var view: DescriptionViewProtocol?
    var details: Description
    var ide: Int
    init(view: DescriptionViewProtocol, model: Description, id: Int, service: MovieAPIService) {
        self.view = view
        details = model
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
