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
    
    let listCellIdAndNibName = "ListCell"

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
        view.backgroundColor = UIColor.backGroundList
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Configure tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: listCellIdAndNibName, bundle: nil),
                           forCellReuseIdentifier: listCellIdAndNibName)
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
            let url = String(format: "%@.%@",
                             String(charty.thumbnail?.path ?? ""),
                             String(charty.thumbnail?.thumbnailExtension ?? ""))
            cell.configure(id: charty.id, imageUrl: url,
                           name: charty.name ?? "",
                           description: charty.resultDescription ?? "This character has an empty or nil description, this is a text to supply it …",
                           comics: charty.comics.items.count,
                           events: charty.events?.count ?? 0,
                           series: charty.events?.count ?? 0)
            cell.tag = indexPath.row
            return cell
        }
        
        return UITableViewCell()
    }

}

// MARK: - Methods of UITableViewDelegate protocol

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navigate to Detail
        //tableView.deselectRow(at: indexPath, animated: true)
        //searchBar.resignFirstResponder()
        //let charId = arrayofcharacters[indexPath.row].id
        //viewModel?.action.onNext(.openDetail(charId))
    }
}
