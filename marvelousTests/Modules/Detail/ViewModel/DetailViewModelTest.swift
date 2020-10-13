//  DetailViewModelTest.swift
//  marvelousTests
//
//  Created by Simón Aparicio on 13/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import XCTest

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import marvelous

class DetailViewModelTest: XCTestCase {

    private var scheduler: TestScheduler!
    private var viewState: TestableObserver<DetailState>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        viewState = scheduler.createObserver(DetailState.self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        
        scheduler = nil
        viewState = nil
    }

    func testLoading(){
        
        let viewModel =  DetailViewModel()
        viewModel.id = 1011334

        // Given
        viewModel.state
            .bind(to: viewState)
            .disposed(by: disposeBag)
        
        // When
        viewModel.requestData(scheduler: scheduler)
        scheduler.start()
        
        // Then
        let state = (viewState.events[0].value).element!

        XCTAssertEqual(state, DetailState.loading)
    }
    
    func testLoaded() {
        
        let viewModel = DetailViewModel()
        viewModel.id = 1011334
        
        // Given
        viewModel.state
            .bind(to: viewState)
            .disposed(by: disposeBag)
        
        // When
        viewModel.requestData(scheduler: scheduler)
        scheduler.start()
        
        // Then wait for request data and state can change
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let state = (self.viewState.events[0].value).element!
            
            switch state {
                case .loaded:
                    XCTAssertEqual(self.viewState.events, [
                                    .next(0, DetailState.loading),
                                    .next(1, DetailState.loaded)
                                    ])
                default:
                    XCTFail()
            }

        }
    }

}
