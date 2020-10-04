//  ListCoordinator.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class ListCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator? // weak because retain memory cycle, parent already owns the child
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showList()
    }
    
    func didStop() {
        parentCoordinator?.childDidStop(self)
        debugPrint("I'm on didStop() -> go to startNextModule()…")
    }
    
    func childDidStop(_ child: Coordinator?) {
        for (index, coordinator) in
            childCoordinators.enumerated() {
                // needs conform to AnyObject and returns true only if its exactly the same object instance
                if coordinator === child {
                    childCoordinators.remove(at: index)
                    break
                }
        }
    }
    
    private func showList() {
        let vc = ListViewController.instantiate(storyboardName: UIStoryboard.Name.main.rawValue)
        if let viewController = vc {
            let viewModel = ListViewModel()

            viewModel.finishModule
                .asObserver()
                .subscribe(onNext: { (finished) in
                    debugPrint("ListCoordinator calling didStop…")
                    self.didStop()
                }).disposed(by: disposeBag)

            viewController.viewModel = viewModel
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }

}
