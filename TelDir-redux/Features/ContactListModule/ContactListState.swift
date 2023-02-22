//
//  ContactListState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation
import ReSwift

struct ContactListState {
    var requestState: ContactListRequestState
    var storageService: ContactListDataStorageService
    
    init(requestState: ContactListRequestState = .initial, storageService: ContactListDataStorageService = ContactListDataStorageService()) {
        self.requestState = requestState
        self.storageService = storageService
    }
}

enum ContactListRequestState {
    case initial
    case isLoading
    case updated([ContactPresentationModel])
    case failure(Error)
}
