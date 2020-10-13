//  ListViewModelTest.swift
//  marvelousTests
//
//  Created by Simón Aparicio on 12/10/2020.
//  Copyright © 2020 iPon.es. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import marvelous

class ListViewModelTest: XCTestCase {

    private var scheduler: TestScheduler!
    private var viewState: TestableObserver<ListState>!
    private var viewAction: TestableObserver<ListAction>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        viewState = scheduler.createObserver(ListState.self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        
        scheduler = nil
        viewState = nil
        viewAction = nil
    }

    func testLoading(){
        
        let viewModel =  ListViewModel()
        
        // Given
        viewModel.state
            .bind(to: viewState)
            .disposed(by: disposeBag)
        
        // When
        viewModel.requestData(scheduler: scheduler)
        scheduler.start()
        
        // Then
        let state = (viewState.events[0].value).element!

        XCTAssertEqual(state, ListState.loading)
    }
    
    func testLoaded() {
        
        let viewModel = ListViewModel()
        
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
                                    .next(0, ListState.loading),
                                    .next(1, ListState.loaded)
                                    ])
                default:
                    XCTFail()
            }

        }
    }

}
