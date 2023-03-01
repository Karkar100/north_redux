//
//  RoutingReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    static func routingReducer(action: Action, state: AppState?) -> RoutingState {
        var state = state ?? AppState(routingState: RoutingState(), contactListState: ContactListState(), oneContactState: OneContactState(image: Image(state: .notDownloaded), contactInfoOptions: .initial, additionalScreen: .none))
        switch action {
            case _ as ShowInitialScreenAction:
                
                state.routingState.navigationState = .initial
            case _ as ShowOneContactScreenAction:
                
                state.routingState.navigationState = .oneContact
        default: break
        }
        return state.routingState
    }
}
