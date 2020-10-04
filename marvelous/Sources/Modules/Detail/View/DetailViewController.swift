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
        view.backgroundColor = UIColor.backGroundDetail
        configureNavBar()
    }
    
    func configureNavBar() {
        ConfigureNavBarAppearance()
        // TODO: Set title from character name
        if let id = viewModel?.id { title = String(format: "ID: %d - Detail View", id) }
        navigationController?.setNavigationBarHidden(false, animated: true)
        //navigationController?.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backTapped))
    }
    
    private func ConfigureNavBarAppearance() {

        let appearance = UINavigationBarAppearance()

        // fonts for navigationbar titles
        appearance.largeTitleTextAttributes = [
            .font: UIFont.AppFont.largeTitle,
            .foregroundColor: UIColor.barTitles]
        appearance.titleTextAttributes = [
            .font: UIFont.AppFont.compactTitle,
            .foregroundColor: UIColor.barTitles]

        // back button
        appearance.setBackIndicatorImage(
            UIImage(systemName: AppConfig.barBack), transitionMaskImage:
            UIImage(systemName: AppConfig.barBackTrans))
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.AppFont.barButton,
            .foregroundColor: UIColor.barButton]

        // transparency
        appearance.configureWithTransparentBackground()

        // apply appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
    
    @objc private func backTapped() {
        viewModel?.closeModule()
    }
    
}
