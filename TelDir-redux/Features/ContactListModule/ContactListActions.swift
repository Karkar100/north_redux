//
//  ContactListActions.swift
//  TelDir-redux
//
//  Created by Diana Princess on 22.02.2023.
//

import Foundation
import ReSwift

protocol ContactListAction: Action {}
enum ContactListActions: Action {
    case loadingSuccessful(ContactListLoadingSuccess)
    case loadingFailure(ContactListLoadingFailure)
    case loadingStarted(ContactListLoadingStarted)
    case filterAction(ContactListFilterAction)
    case deactivateFilteringAction(DeactivateFilteringAction)
    case updateOneThumbnail(UpdateThumbnailAction)
}

struct ContactListLoadingSuccess: ContactListAction {
    let contacts: [ContactItem]
}

struct ContactListFilterAction: ContactListAction {
    let filterString: String
}

struct DeactivateFilteringAction: ContactListAction {}

struct UpdateThumbnailAction: ContactListAction {
    let id: String
    let result: ImageDownloadingResult
}

struct ContactListLoadingFailure: ContactListAction {
    let error: Error
}

struct ContactListLoadingStarted: ContactListAction {}
