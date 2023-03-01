//
//  ContactListReducer.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

extension Reducers {
    static func contactListReducer(action: Action, state: AppState?) -> ContactListState {
        var state = state ?? AppState(routingState: RoutingState(), contactListState: ContactListState(), oneContactState: OneContactState(image: Image(state: .notDownloaded), contactInfoOptions: .initial, additionalScreen: .none))
        switch action {
            case let loadingSuccessfulAction as ContactListLoadingSuccess:
                loadingSuccessfulAction.contacts.forEach{ state.contactListState.storageService.addContact($0) }
                state.contactListState.requestState = .updated(state.contactListState.storageService.getAllContacts())
            case let loadingFailureAction as ContactListLoadingFailure:
                state.contactListState.requestState = .failure(loadingFailureAction.error)
            case _ as ContactListLoadingStarted:
                state.contactListState.requestState = .isLoading
            case let filterAction as ContactListFilterAction:
                state.contactListState.requestState = .updated(state.contactListState.storageService.filterContactList(filterAction.filterString))
            case _ as DeactivateFilteringAction:
                state.contactListState.requestState = .updated(state.contactListState.storageService.getAllContacts())
            case let updateThumbnailAction as UpdateThumbnailAction:
                state.contactListState.storageService.updateThumbnail(for: updateThumbnailAction.id, result: updateThumbnailAction.result)
                state.contactListState.requestState = .updated(state.contactListState.storageService.getAllContacts())
            default: break
        }
        return state.contactListState
    }
}
