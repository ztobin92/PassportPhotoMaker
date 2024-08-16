//
//  ProcessingViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 15.06.2023.
//  Copyright © 2023 Mobillium. All rights reserved.
//

import Foundation
import Combine

protocol ProcessingViewDataSource {}

protocol ProcessingViewEventSource {}

protocol ProcessingViewProtocol: ProcessingViewDataSource, ProcessingViewEventSource {}

final class ProcessingViewModel: BaseViewModel<ProcessingRouter>, ProcessingViewProtocol {
    
    var cancellable = Set<AnyCancellable>()
    
    init(router: ProcessingRouter) {
        super.init(router: router)
        closeProcessing.sink { _ in
            router.close()
        }.store(in: &cancellable)
    }
}
