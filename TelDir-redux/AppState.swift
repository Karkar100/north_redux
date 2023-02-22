//
//  AppState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 14.02.2023.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var routingState: RoutingState
    var contactListState: ContactListState
    var oneContactState: OneContactState
}
