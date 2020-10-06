//  ViewController.swift
//  marvelous
//
//  Created by Simón Aparicio on 03/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let listCellIdAndNibName = "ListCell"
    private var isNavBarSettedToHidden = false // Default value for navBar visibility
    private var refreshControl = UIRefreshControl()
    
    private let emptyOrNilDescription = "This character has an empty or nil description, this is a text to supply it …"
    private let pullToText = "Pull to show navBar"
    private let listTitle = "The Marvel List"

    weak var coordinator: ListCoordinator?
    var viewModel: ListViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarVisibility(isHidden: isNavBarSettedToHidden)
    }

    private func configureView() {
        
        view.backgroundColor = UIColor.backGroundList
        configureNavBar()
        
        // Configure tableView
        refreshControl.attributedTitle = NSAttributedString(string: pullToText,
                                                            attributes: [.font:UIFont.AppFont.bodyText])
        refreshControl.addTarget(self, action: #selector(showNavBar), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Content goes under navBar and statusBar ignoring safe area
        //tableView.contentInsetAdjustmentBehavior = .never

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: listCellIdAndNibName, bundle: nil),
                           forCellReuseIdentifier: listCellIdAndNibName)
    }
    
    private func configureNavBar() {
        
        title = listTitle
        let rightBarImageConfig = UIImage.SymbolConfiguration(font: UIFont.AppFont.rightBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: AppConfig.barRightList,
                           withConfiguration: rightBarImageConfig),
            style: .plain, target: self, action: #selector(hideNavBar))
        
        // To remove the default text "Back" for backBarButton in Detail
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    private func navBarVisibility(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    
    @objc private func hideNavBar() {
        navBarVisibility(isHidden: true)
        isNavBarSettedToHidden = true
    }
    
    @objc private func showNavBar() {
        navBarVisibility(isHidden: false)
        isNavBarSettedToHidden = false
        refreshControl.endRefreshing()
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else { return }
        let state = viewModel.state.asObservable()
        
        // Suscribe to List states
        state.subscribe(onNext: { (state) in
            switch state {
                case .loading:
                    // TODO: ActivityIndicator start, isHidden and hidesWhenStopped
                    debugPrint("Loading State in ListViewController…")
                    break
                case .error(let error):
                    // TODO: show error message and stop ActivityIndicator
                    self.showErrorMessage(error)
                case .loaded:
                    debugPrint("Loaded State in ListViewController")
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        // Launch request data flow
        viewModel.requestData(scheduler: MainScheduler.instance)
    }
    
    private func showErrorMessage(_ error: ErrorResponse) { // TODO: Show error message to user
        debugPrint("showErrorMessage() in ListViewController…")
    }
    
}

// MARK: - Methods of UITableViewDataSource protocol

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chars.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: listCellIdAndNibName, for: indexPath) as? ListCell {
        
            guard let charty = viewModel?.chars[indexPath.row] else { return UITableViewCell() }
            
            // Control of empties or nils descriptions, because need some text in the cell even when there aren't
            var isEmptyDescription = false
            if let isEmpty = charty.resultDescription?.isEmpty, isEmpty { isEmptyDescription = true }
            let url = String(format: "%@.%@",
                             String(charty.thumbnail?.path ?? ""),
                             String(charty.thumbnail?.thumbnailExtension ?? ""))
            
            cell.configure(id: charty.id, imageUrl: url,
                           name: charty.name ?? "nil Name",
                           description: isEmptyDescription ?
                                        emptyOrNilDescription :
                                        charty.resultDescription ?? emptyOrNilDescription,
                           comics: charty.comics.items.count,
                           events: charty.events?.count ?? 0,
                           series: charty.events?.count ?? 0)
            return cell
        }
        return UITableViewCell()
    }

}

// MARK: - Methods of UITableViewDelegate protocol

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        guard let charty = viewModel?.chars[indexPath.row] else { return }
        viewModel?.action.onNext(.openDetail(charty.id))
    }
}

// MARK: - Methods of UIScrollViewDelegate

extension ListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // TODO: Do something when scrolling
    }
}
