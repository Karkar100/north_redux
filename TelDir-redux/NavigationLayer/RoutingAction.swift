//
//  RoutingAction.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

struct RoutingAction: Action {
    var navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination) {
        self.navigationState = navigationState
    }
}

extension RoutingAction: RoutingActionProtocol {
    
    func navigate(_ destination: RoutingDestination) -> [Action] {
        switch destination {
        case .initial:
            return [ShowInitialScreenAction()]
        case .oneContact:
            return [ShowOneContactScreenAction()]
        }
    }
}

struct ShowInitialScreenAction: Action {
    
}

struct ShowOneContactScreenAction: Action {
    
}
