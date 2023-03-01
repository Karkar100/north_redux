//
//  RoutingState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

struct RoutingState {
    var navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination = .initial) {
        self.navigationState = navigationState
    }
}

enum RoutingDestination: String {
    case initial = "initial"
    case oneContact = "OneContactVC"
}
