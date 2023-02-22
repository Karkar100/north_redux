//
//  ContactListReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    static func contactListReducer(action: Action, state: ContactListState?) -> ContactListState {
        switch action {
            case let displayErrorAction as DisplayErrorAction:
                guard var state = state else { return ContactListState() }
                state.requestState = .failure(displayErrorAction.error)
                return state
            case let transformAction as ContactListTransformAction:
                guard var state = state else { return ContactListState() }
                transformAction.source.forEach { state.storageService.addContact($0) }
                state.requestState = .updated(state.storageService.getAllContacts())
                return state
            case let filterAction as ContactListFilterAction:
                guard var state = state else { return ContactListState() }
                state.requestState = .updated(state.storageService.filterContactList(filterAction.filterString))
                return state
            case _ as DeactivateFilteringAction:
                guard var state = state else { return ContactListState() }
                state.requestState = .updated(state.storageService.getAllContacts())
                return state
            case let updateThumbnailAction as UpdateThumbnailAction:
                guard var state = state else { return ContactListState() }
                state.storageService.updateThumbnail(for: updateThumbnailAction.id, result: updateThumbnailAction.result)
                state.requestState = .updated(state.storageService.getAllContacts())
                return state
            default:
                return state ?? ContactListState()
        }
    }
}
