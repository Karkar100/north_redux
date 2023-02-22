//
//  RoutingReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    static func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
        var state = state ?? RoutingState()
        switch action {
            case let routingAction as RoutingAction:
              state.navigationState = routingAction.destination
            default: break
        }
        return state
    }
}
