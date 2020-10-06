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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Use this because need to trigger finishModule PublishSubject when user tap back BarButton
        // but wants to use the default iOS appearance for backBarButton (re-defined in AppDelegate)
        if self.isMovingFromParent {
            backTapped()
        }
    }

    private func configureView() {

        view.backgroundColor = UIColor.backGroundDetail
        configureNavBar()
    }
    
    private func configureNavBar() {
        //if let id = viewModel?.id { title = String(format: "%d Detail", id) }
        navigationItem.backBarButtonItem?.title = "backTitleDetail"
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        let state = viewModel.state.asObservable()
        
        // Suscribe to Detail states
        state.subscribe(onNext: { (state) in
            switch state {
                case .loading:
                    // TODO: ActivityIndicator start, isHidden and hidesWhenStopped
                    debugPrint("Loading State in DetailViewController…")
                    break
                case .error(let error):
                    // TODO: show error message and stop ActivityIndicator
                    self.showErrorMessage(error)
                case .loaded:
                    debugPrint("Loaded State in DetailViewController")
                }
            }).disposed(by: disposeBag)
        
        // Request Detail data from webservice
        viewModel.requestData(scheduler: MainScheduler.instance)
    }
    
    private func showErrorMessage(_ error: ErrorResponse) { // TODO: Show error message to user
        debugPrint("showErrorMessage() in DetailViewController…")
    }
    
    private func backTapped() {
        viewModel?.closeModule()
    }
    
}
