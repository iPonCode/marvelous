//  DetailViewController.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var headerImageHeight: NSLayoutConstraint!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var resultDescription: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
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
        headerImageHeight.constant = AppConfig.maxHeaderImageHeight
        name.font = UIFont.AppFont.largeTitle
        id.font = UIFont.AppFont.compactTitle
        id.textColor = UIColor.secondaryLabel
        resultDescription.font = UIFont.AppFont.bodyText
        
        segmentedControl.setTitleTextAttributes([.font:UIFont.AppFont.segmentedText], for: .normal)
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
                    self.paintData()
                }
            }).disposed(by: disposeBag)
        
        // Request Detail data from webservice
        viewModel.requestData(scheduler: MainScheduler.instance)
    }
    
    private func paintData() {
        
        guard let charty = viewModel?.charty else { return }
        
        name.text = charty.name
        id.text = String(charty.id)
        resultDescription.text = charty.resultDescription.isEmpty ?
                                 AppConfig.emptyOrNilDescription :
                                 charty.resultDescription
        
        let url = String(format: "%@.%@",
                         String(charty.thumbnail.path),
                         String(charty.thumbnail.thumbnailExtension))

        // Try to load image from the url
        guard let imageUrl = URL(string: url) else {
            setPlaceholderForHeaderImage()
            return
        }
        
        // If webservice returns a valid url image for not avilable, prefer use own placeholder
        imageUrl.absoluteString.contains(AppConfig.imgNotAvailablePattern) ?
            setPlaceholderForHeaderImage() :
            headerImage.af.setImage(withURL: imageUrl)
        
    }
    
    private func setPlaceholderForHeaderImage() {
        headerImage.image = UIImage(named: "placeholder-header")
    }
    
    private func showErrorMessage(_ error: ErrorResponse) { // TODO: Show error message to user
        debugPrint("showErrorMessage() in DetailViewController…")
    }
    
    private func backTapped() {
        viewModel?.closeModule()
    }
    
}
