//  DetailCoordinatorTest.swift
//  marvelousTests
//
//  Created by Simón Aparicio on 13/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import XCTest

@testable import marvelous

class DetailCoordinatorTest: XCTestCase {

    var navigationController: UINavigationController!
    
    override func setUp() {
        
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        navigationController = nil
    }
    
    func testStartStop() {
        
        let coordinator = DetailCoordinator(navigationController: navigationController, id: 1011334)
        coordinator.start()
        XCTAssertNotNil(navigationController.viewControllers.last as? DetailViewController)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            coordinator.didStop()
            XCTAssertNil(self.navigationController.viewControllers.last as? DetailViewController)
        }
    }
    
}
