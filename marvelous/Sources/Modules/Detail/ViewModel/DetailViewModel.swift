//  DetailViewModel.swift
//  marvelous
//
//  Created by Simón Aparicio on 04/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum DetailState : Equatable {
    
    case loading
    case error (ErrorResponse)
    case loaded

    static func == (lhs: DetailState, rhs: DetailState) -> Bool { // to conform Equatable
        switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (let .error(lhsError), let .error(rhsError)):
                return lhsError.code == rhsError.code
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
    var charty = CharacterDTO()
    private var serverError = ErrorResponse()

    init() {
        self.state = PublishSubject<DetailState>()
        self.finishModule = PublishSubject<Bool>()
    }

    func requestData(scheduler: SchedulerType) {
        
        state.onNext(.loading)
        guard let id = id,
              let url = URL(string: MarvelApi.getDetailsUrl(id)) else { return }

        AF.request(url).responseJSON { [weak self] response in
            // here needs weak self to don't have a strong reference to self when this closure run
            guard let weakSelf = self else { return }

            guard let serverData = response.data,
                  let networkResponse = try? JSONDecoder().decode(NetworkDetailResponseDTO.self, from: serverData) else {
        
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
                if let char = networkResponse.data?.results.first {
                    weakSelf.charty = char
                    weakSelf.state.onNext(.loaded)
                }
            }
        }
        
    }
    
    func closeModule() {
        finishModule.onNext(true)
    }

}
