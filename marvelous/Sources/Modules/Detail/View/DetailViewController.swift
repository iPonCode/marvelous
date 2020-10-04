//  DetailViewController.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    weak var coordinator: DetailCoordinator?
    var viewModel: DetailViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViewModel()
    }

    func configureView() {
        // TODO: Configure view
        view.backgroundColor = .systemIndigo
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        let state = viewModel.state.asObservable()
        
        // Suscribe to Detail states
        state.subscribe(onNext: { (state) in
            switch state {
                case .loading:
                    //TODO: ActivityIndicator start, isHidden and hidesWhenStopped
                    debugPrint("Loading State in DetailViewController…")
                    break
                case .error(let error):
                    //TODO: show error message and stop ActivityIndicator
                    self.showErrorMessage(error)
                case .loaded:
                    debugPrint("Loaded State in DetailViewController")
                }
            }).disposed(by: disposeBag)
        
        // Request Detail data from webservice
        viewModel.requestData(scheduler: MainScheduler.instance)
    }
    
    private func showErrorMessage(_ error: Error) { // TODO: Show error message to user
        debugPrint("showErrorMessage() in DetailViewController…")
    }
    
}
