//  ListViewModel.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import Foundation
import RxSwift

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
    case error (Error)
    case loaded
    // TODO: maybe will need to additional checks (like jailbroken device, App needToUpdate, etc..)

    static func == (lhs: ListState, rhs: ListState) -> Bool { // to conform Equatable
        switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (let .error(lhsError), let .error(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
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
        
    init() {
        self.state = PublishSubject<ListState>()
        self.action = PublishSubject<ListAction>()
    }

    func requestData(scheduler: SchedulerType) {
        
        // TODO: requestData from webservice
        self.state.onNext(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state.onNext(.loaded)
        }
    }

}
