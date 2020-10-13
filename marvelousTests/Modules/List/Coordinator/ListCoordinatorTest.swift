//  ListCoordinatorTest.swift
//  marvelousTests
//
//  Created by Simón Aparicio on 13/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import XCTest

@testable import marvelous

class ListCoordinatorTest: XCTestCase {

    var navigationController: UINavigationController!
    
    override func setUp() {
        
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        navigationController = nil
    }
    
    func testStartStop() {
        
        let coordinator = ListCoordinator(navigationController: navigationController)
        coordinator.start()
        XCTAssertNotNil(navigationController.viewControllers.last as? ListViewController)
        
        // wait for start request data
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            coordinator.didStop()
            XCTAssertNil(self.navigationController.viewControllers.last as? ListViewController)
        }
    }
    
}
