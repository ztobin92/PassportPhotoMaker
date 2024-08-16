//
//  WelcomePromptViewModel.swift
//  NewWatchFacesApp
//
//  Created by Bora Erdem on 22.05.2023.
//

import Foundation

protocol WelcomePromptViewDataSource {}

protocol WelcomePromptViewEventSource {}

protocol WelcomePromptViewProtocol: WelcomePromptViewDataSource, WelcomePromptViewEventSource {}

final class WelcomePromptViewModel: BaseViewModel<WelcomePromptRouter>, WelcomePromptViewProtocol {
}
