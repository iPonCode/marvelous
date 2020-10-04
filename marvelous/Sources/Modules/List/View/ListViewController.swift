//  ViewController.swift
//  marvelous
//
//  Created by Simón Aparicio on 03/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {

    weak var coordinator: ListCoordinator?
    var viewModel: ListViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViewModel()
    }

    func configureView() {
        // TODO: Configure view
        view.backgroundColor = .purple
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        let state = viewModel.state.asObservable()
        
        // Suscribe to List states
        state.subscribe(onNext: { (state) in
            switch state {
                case .loading:
                    //TODO: ActivityIndicator start, isHidden and hidesWhenStopped
                    debugPrint("Loading State in ListViewController…")
                    break
                case .error(let error):
                    //TODO: show error message and stop ActivityIndicator
                    self.showErrorMessage(error)
                case .loaded:
                    debugPrint("Loaded State in ListViewController -> navigateNextModule()")
                    viewModel.navigateNextModule()
                }
            }).disposed(by: disposeBag)
        
        // Launch request data flow
        viewModel.requestData(scheduler: MainScheduler.instance)
    }
    
    private func showErrorMessage(_ error: Error) { // TODO: Show error message to user
        debugPrint("showErrorMessage() in SplasViewController…")
    }
    
    @IBAction func goToDetail(_ sender: Any) {
        // TODO: Navigate to Detail. Provisional button to show DetailViewController
        debugPrint("Go To DetailViewController tapped!")
    }
}
