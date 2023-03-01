//
//  RoutingActionProtocol.swift
//  TelDir-redux
//
//  Created by Diana Princess on 28.02.2023.
//

import Foundation
import ReSwift

protocol RoutingActionProtocol {
    var navigationState: RoutingDestination { get }
    func navigate(_ destination: RoutingDestination) -> [Action]
}
