//  AppCoordinator.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    // UINavigationControllerDelegate needed to detect interaction with the
    // NavigationControllers directly, thats its possible only if subclass NSObject
    
    // MARK: Coordinator methods
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startList()
    }
    
    func childDidStop(_ child: Coordinator?) {
        for (index, coordinator) in
            childCoordinators.enumerated() {
                // Needs to conform to AnyObject and returns true only if its exactly the same object instance
                if coordinator === child {
                    childCoordinators.remove(at: index)
                    break
                }
        }
    }
    
    func startList() {
        // TODO: Start ListCoordinator
        debugPrint("start ListCoordinator here")
    }
    
}

// MARK: UINavigationControllerDelegate
extension AppCoordinator: UINavigationControllerDelegate {

    // Called just after the navigation controller displays a view controller’s view and navigation item properties
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        
        // First needs to read the ViewController we're moving from
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Second checks whether our ViewController array already contains that ViewController and if it does
        // that means there are pushing a different ViewController on top rather than popping it
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // Third call didStop if for correspondent ViewController
        // TODO: If firstViewController was ListViewController call chillDidStop
        
    }
    
}
