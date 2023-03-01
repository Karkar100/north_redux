//
//  OneContactReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    
    static func oneContactReducer(action: Action, state: AppState?) -> OneContactState {
        var state = state ?? AppState(routingState: RoutingState(), contactListState: ContactListState(), oneContactState: OneContactState(image: Image(state: .notDownloaded), contactInfoOptions: .initial, additionalScreen: .none))
        switch action {
            case let updateContactAction as UpdateOneContactAction:
                guard let contact = state.contactListState.storageService.getContactDomainModel(id: updateContactAction.id) else { return state.oneContactState }
                guard let countryCode = state.countryCodes[contact.nat] else { return state.oneContactState }
                let unfilteredPhone = countryCode + "-" + contact.phone
                let unfilteredCell = countryCode + "-" + contact.cell
                let fullPhone = unfilteredPhone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                let fullCell = unfilteredCell.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                let contactInfo = ContactDetailedInfo(fullname: contact.fullname, phone: fullPhone, cell: fullCell, email: contact.email, imageURL: contact.largeImageStr)
                state.oneContactState.contactInfoOptions = .updated(contactInfo)
            case let updateImageAction as UpdateImageAction:
                switch updateImageAction.result {
                    case .isCancelled:
                        state.oneContactState.image.state = .notDownloaded
                    case .success(let data):
                        guard let data = data else { return state.oneContactState }
                        state.oneContactState.image.state = .downloaded(data)
                    case .failure(_):
                        state.oneContactState.image.state = .failed
                }
            default: break
        }
        return state.oneContactState
    }
}
