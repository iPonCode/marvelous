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
        debugPrint("I'm on didStop()")
    }
    
    func childDidStop(_ child: Coordinator?) {
        for (index, coordinator) in
            childCoordinators.enumerated() {
                // needs conform to AnyObject and returns true only if its exactly the same object instance
                if coordinator === child {
                    // This popViewController it's not necessary when child is using default back button action
                    //navigationController.popViewController(animated: true)
                    childCoordinators.remove(at: index)
                    break
                }
        }
    }
    
    private func showList() {
        let vc = ListViewController.instantiate(storyboardName: UIStoryboard.Name.main.rawValue)
        if let viewController = vc {
            let viewModel = ListViewModel()
            
            viewModel.action
                .asObserver()
                .subscribe(onNext: { (action) in
                    switch action {
                    case .openDetail(let id):
                        self.openDetail(id)
                    case .finish:
                        break
                    case .none:
                        break
                    }
                }).disposed(by: disposeBag)

            viewController.viewModel = viewModel
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func openDetail(_ id: Int?) {
        
        guard let id = id else { return }
        let child = DetailCoordinator(navigationController: navigationController, id: id)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()

    }

}
