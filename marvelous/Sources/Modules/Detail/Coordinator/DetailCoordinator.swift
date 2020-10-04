//  DetailCoordinator.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class DetailCoordinator: Coordinator {
    
    weak var parentCoordinator: ListCoordinator? // weak because retain memory cycle, parent already owns the child
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let disposeBag = DisposeBag()
    private var id: Int?

    init(navigationController: UINavigationController, id: Int?) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        showDetail()
    }
    
    func didStop() {
        debugPrint("I'm on didStop()")
        parentCoordinator?.childDidStop(self)
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
    
    private func showDetail() {
        let vc = DetailViewController.instantiate(storyboardName: UIStoryboard.Name.main.rawValue)
        if let viewController = vc {
            let viewModel = DetailViewModel()
            viewModel.id = self.id

            viewModel.finishModule
                .asObserver()
                .subscribe(onNext: { (finished) in
                    debugPrint("DetailCoordinator calling didStop…")
                    self.didStop()
                }).disposed(by: disposeBag)

            viewController.viewModel = viewModel
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }

}
