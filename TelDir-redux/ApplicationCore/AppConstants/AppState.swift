//
//  AppState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 14.02.2023.
//

import Foundation
import ReSwift

struct AppState {
    var routingState: RoutingState
    var contactListState: ContactListState
    var oneContactState: OneContactState
    let countryCodes: [String: String] = [
        "AU": "61",
        "BR": "55",
        "CA": "1",
        "CH": "41",
        "DE": "49",
        "DK": "45",
        "ES": "34",
        "FI": "358",
        "FR": "32",
        "GB": "44",
        "IE": "353",
        "IN": "91",
        "IR": "98",
        "MX": "52",
        "NL": "31",
        "NO": "47",
        "NZ": "64",
        "RS": "381",
        "TR": "90",
        "UA": "380",
        "US": "1"
    ]
}
