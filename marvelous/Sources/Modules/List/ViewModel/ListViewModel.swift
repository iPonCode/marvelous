//  ListViewModel.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import RxSwift
import Alamofire

enum ListAction : Equatable {
    case openDetail(Int?)
    case finish
    case none
    
    static func == (lhs: ListAction, rhs: ListAction) -> Bool {
        switch (lhs, rhs) {
        case (let .openDetail(lhsId), let .openDetail(rhsId)):
            return lhsId == rhsId
        case (.finish, .finish):
            return true
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

enum ListState : Equatable {
    
    case loading
    case error (ErrorResponse)
    case loaded
    // TODO: maybe will need additional checks (like jailbroken device, App needs an update, etc..)

    static func == (lhs: ListState, rhs: ListState) -> Bool { // to conform Equatable
        switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (let .error(lhsError), let .error(rhsError)):
                return lhsError.code == rhsError.code
            case (.loaded, .loaded): return true
            default: return false
        }
    }
}

protocol ListViewModelProtocol {
    var state: PublishSubject<ListState> { get }
    var action: PublishSubject<ListAction> { get }
    
    func requestData(scheduler: SchedulerType)
}

class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Outputs
    var state: PublishSubject<ListState>
    var action: PublishSubject<ListAction>
    
    var chars = [CharacterListItemDTO]()
    private var serverError = ErrorResponse()
        
    init() {
        self.state = PublishSubject<ListState>()
        self.action = PublishSubject<ListAction>()
    }

    func requestData(scheduler: SchedulerType) {
        
        state.onNext(.loading)
        guard let url = URL(string: MarvelApi.getCharactersListUrl()) else { return }

        AF.request(url).responseJSON { [weak self] response in
            // here needs weak self to don't have a strong reference to self when this closure run
            guard let weakSelf = self else { return }
        
            guard let serverData = response.data,
                  let networkResponse = try? JSONDecoder().decode(NetworkListResponseDTO.self, from: serverData) else {
        
                guard let serverData = response.data,
                      let errorObject = try? JSONDecoder().decode(ErrorResponse.self, from: serverData) else {
                    
                    // Cannot decode the current error message, save generic error when don't know what error it is
                    weakSelf.serverError.code = "Generic"
                    weakSelf.serverError.message = "Generic server error - Cannot decode error message"
                    weakSelf.state.onNext(.error(weakSelf.serverError))
                    return
                }
        
                // Save any other error, when know what error it is
                weakSelf.serverError = errorObject
                weakSelf.state.onNext(.error(weakSelf.serverError))
                return
            }
            
            DispatchQueue.main.async {
                if let characters = networkResponse.data?.results {
                    weakSelf.chars = characters
                    weakSelf.state.onNext(.loaded)
                }
            }
        }
        
    }
    
}
