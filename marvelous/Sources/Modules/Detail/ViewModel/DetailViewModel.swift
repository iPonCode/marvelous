//  DetailViewModel.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import Foundation
import RxSwift

enum DetailState : Equatable {
    
    case loading
    case error (Error)
    case loaded

    static func == (lhs: DetailState, rhs: DetailState) -> Bool { // to conform Equatable
        switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (let .error(lhsError), let .error(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.loaded, .loaded): return true
            default: return false
        }
    }
}

protocol DetailViewModelProtocol {
    var state: PublishSubject<DetailState> { get }
    var finishModule: PublishSubject<Bool> { get }
    
    func requestData(scheduler: SchedulerType)
    func closeModule()
}

class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Outputs
    var state: PublishSubject<DetailState>
    var finishModule: PublishSubject<Bool>
    
    var id: Int?
        
    init() {
        self.state = PublishSubject<DetailState>()
        self.finishModule = PublishSubject<Bool>()
    }

    func requestData(scheduler: SchedulerType) {
        
        // TODO: requestData from webservice
        self.state.onNext(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state.onNext(.loaded)
        }
    }

    func closeModule() {
        finishModule.onNext(true)
    }

}
