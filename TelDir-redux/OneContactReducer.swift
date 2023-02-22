//
//  OneContactReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    private static let countryCodes: [String: String] = [
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
    
    static func oneContactReducer(action: Action, state: OneContactState?) -> OneContactState {
        var state = state ?? OneContactState(image: Image(state: .notDownloaded), contactInfoOptions: .initial, additionalScreen: .none)
        switch action {
            case let updateImageAction as UpdateImageAction:
            switch updateImageAction.result {
                case .isCancelled:
                    state.image.state = .notDownloaded
                case .success(let data):
                    guard let data = data else { return state }
                    state.image.state = .downloaded(data)
                case .failure(_):
                    state.image.state = .failed
            }
            case let updateContactAction as UpdateOneContactAction:
                let contact = updateContactAction.contactItem
                guard let countryCode = countryCodes[contact.nat] else { return state }
                let unfilteredPhone = countryCode + "-" + contact.phone
                let unfilteredCell = countryCode + "-" + contact.cell
                let fullPhone = unfilteredPhone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                let fullCell = unfilteredCell.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                let contactInfo = ContactDetailedInfo(fullname: contact.fullname, phone: fullPhone, cell: fullCell, email: contact.email, imageURL: contact.largeImageStr)
                state.contactInfoOptions = .updated(contactInfo)
            default:
                break
        }
        return state
    }
}
