//
//  AppReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 14.02.2023.
//

import Foundation
import ReSwift

enum Reducers {
    static func appReducer(action: Action, state: AppState?) -> AppState {
        return AppState(
            routingState: Reducers.routingReducer(action: action, state: state),
            contactListState: Reducers.contactListReducer(action: action, state: state),
            oneContactState: Reducers.oneContactReducer(action: action, state: state)
        )
    }
}
