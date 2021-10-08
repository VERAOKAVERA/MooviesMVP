// MainPresenterTests.swift
// Copyright © RoadMap. All rights reserved.

//
//  MainPresenterTests.swift
//  MooviesTests
//
//  Created by Vera Zaitseva on 08.10.2021.
//
import Foundation
@testable import Moovies
import XCTest

final class MainMockView: MainViewProtocol {
    func reloadTable() {}
    var films = MoviesResult(results: [], totalResults: 0, totalPages: 0, page: 0)
    func getMoviesOfType(_ type: MoviesType) {}
    func openMoovieDescription(film: Movie) {}
    func success() {}
    func failure(error: Error) {}
}

final class MainMockNetworkService: MovieAPIServiceProtocol {
    func getMovieDescriptionService(id: Int, completion: @escaping (Result<Description, Error>) -> Void) {}

    func getMoviesOfTypeService(_ type: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if let film = film {
            completion(.success([film]))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }

    var film: Movie!

    init() {}

    convenience init(film: Movie?) {
        self.init()
        self.film = film
    }
}

final class MainPresenterTest: XCTestCase {
    var view: MainMockView!
    var presenter: MainPresentor!
    var networkService: MovieAPIServiceProtocol!
    var router: RouterProtocol!
    var film: Movie!

    override func setUpWithError() throws {
        let navigationController = UINavigationController()
        let assemblyBuilder = MoviewModules()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
    }

    override func tearDownWithError() throws {
        view = nil
        networkService = nil
        presenter = nil
    }

    func testSuccessFilm() {
        film = Movie(posterPath: "", overview: "", title: "", releaseDate: "", id: 1, voteAverage: 1)
        view = MainMockView()
        networkService = MainMockNetworkService(film: film)
        presenter = MainPresentor(
            view: view,
            service: networkService,
            router: router,
            coreDataService: DataStorageService()
        )
        var catchFilm: Movie?

        networkService.getMoviesOfTypeService(
            "popular"
        ) { result in
            switch result {
            case let .success(film):
                catchFilm = film.first
            case let .failure(error):
                print(error.localizedDescription)
            }
        }

        XCTAssertNotNil(catchFilm)
    }
}
