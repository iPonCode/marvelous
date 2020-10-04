//  ListViewModel.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import Foundation
import RxSwift

enum ListViewState : Equatable {
    
    case loading
    case error (Error)
    case loaded
    // TODO: maybe will need to additional checks (like jailbroken device, App needToUpdate, etc..)

    static func == (lhs: ListViewState, rhs: ListViewState) -> Bool { // to conform Equatable
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
    var state: PublishSubject<ListViewState> { get }
    var finishModule: PublishSubject<Bool> { get }
    
    func requestData(scheduler: SchedulerType)
    func navigateNextModule()
}

class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Outputs
    var state: PublishSubject<ListViewState>
    var finishModule: PublishSubject<Bool>
        
    init() {
        self.state = PublishSubject<ListViewState>()
        self.finishModule = PublishSubject<Bool>()
    }

    func requestData(scheduler: SchedulerType) {
        
        // TODO: requestData from webservice
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state.onNext(.loading)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state.onNext(.loaded)
        }
    }

    func navigateNextModule() {
        finishModule.onNext(true)
    }

}
