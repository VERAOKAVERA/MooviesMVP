// SecondScreenTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import Moovies
import XCTest

final class MockViewDetails: DescriptionViewProtocol {
    func reloadTable() {}
}

final class MockDetailsMovieAPIService: MovieAPIServiceProtocol {
    var details: Description!
    var getDetailsFilmCounter = Int()

    init() {}

    convenience init(details: Description?) {
        self.init()
        self.details = details
    }

    func getMoviesOfTypeService(_ type: String, completion: @escaping (Result<[Movie], Error>) -> Void) {}

    func getMovieDescriptionService(id: Int, completion: @escaping (Result<Description, Error>) -> Void) {
        if let details = details {
            completion(.success(details))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}

final class DetailsMoviePresenterTest: XCTestCase {
    var presenter: DescriptionViewPresentorProtocol!
    var view: DescriptionViewProtocol!
    var router: Router!
    var movieAPIService: MockDetailsMovieAPIService!
    var details: Description?
    var navController: UINavigationController!
    var assembly: MoviewModules!

    override func setUpWithError() throws {
        navController = UINavigationController()
        assembly = MoviewModules()
        view = MockViewDetails()
        router = Router(navigationController: navController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        presenter = nil
        view = nil
        router = nil
        movieAPIService = nil
        navController = nil
        assembly = nil
        details = nil
    }

    func testGetMovieFromRequestSuccess() {
        let movieAPIServiceDetails = MovieAPIService()
        let dataStorageService = DetailsDataStorageService()
        let view = MockViewDetails()
        let assembly = MoviewModules()
        let router = Router(navigationController: navController, assemblyBuilder: assembly)
        presenter = DescriptionPresentor(
            view: view,
            id: 33333,
            service: movieAPIServiceDetails,
            router: router,
            dataStorageService: dataStorageService
        )

        var catchDetails = Description(posterPath: "", title: "", overview: "")
        presenter.getMoovieDescription()
        movieAPIService.getMovieDescriptionService(id: 22321) { response in
            switch response {
            case let .success(details):
                catchDetails = details
            case let .failure(error):
                print(error.localizedDescription)
            }
        }

        XCTAssertEqual(movieAPIService.getDetailsFilmCounter, 2)
        XCTAssertNotNil(catchDetails)
    }
}
