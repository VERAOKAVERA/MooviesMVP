// UnitTestRouter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import Moovies
import XCTest

final class MockNavigationControllet: UINavigationController {
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: true)
    }
}

final class RouterTest: XCTestCase {
    var router: RouterProtocol!
    var navigationController = MockNavigationControllet()
    let assemblerBuilder = ModulesBuilder()

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assemblerBuilder)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testRouterDetailSuccess() {
        router.showDetails(films: nil, id: 0)
        let moovieDescriprionViewController = navigationController.presentedVC
        XCTAssertTrue(moovieDescriprionViewController is MoovieDescriptionTableViewController)
    }

    func testRouterInitialSucces() {
        router.initialViewController()
        let firstViewController = navigationController.viewControllers[0]
        XCTAssertTrue(firstViewController is MooviesViewController)
    }
}
