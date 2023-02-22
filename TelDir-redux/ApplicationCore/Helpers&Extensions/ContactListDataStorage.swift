//
//  ContactListDataStorage.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation

class ContactListDataStorageService {
    private var indexDict: [String: Int] = [:]
    private var allContacts: [ContactPresentationModel] = []
    private var domainModelsDict: [String: ContactItem] = [:]
    private var filterString: String = ""
    private var filteringState: ContactListFilteringState = .notFiltered
    
    func addContact(_ contact: ContactItem) {
        let contactId = UUID().uuidString
        domainModelsDict[contactId] = contact
        let presentationModel = turnDomainModelIntoPresentation(domainModel: contact, id: contactId)
        allContacts.append(presentationModel)
        let index = allContacts.count - 1
        indexDict[contactId] = index
    }
    
    private func getContactPresentationModel(id: String) -> ContactPresentationModel? {
        guard let index = indexDict[id] else { return nil }
        return allContacts[index]
    }
    
    func getContactDomainModel(id: String) -> ContactItem? {
        return domainModelsDict[id]
    }
    
    func getAllContacts() -> [ContactPresentationModel] {
        filteringState = .notFiltered
        return allContacts
    }
    
    private func turnDomainModelIntoPresentation(domainModel: ContactItem, id: String) -> ContactPresentationModel {
        return ContactPresentationModel(fullname: domainModel.fullname, thumbnailString: domainModel.thumbnailString, thumbnail: Image(state: .notDownloaded), id: id)
    }
    
    func updateThumbnail(for id: String, result: ImageDownloadingResult) {
        guard let index = indexDict[id] else { return }
        switch result {
        case .isCancelled:
            allContacts[index].thumbnail.state = .notDownloaded
        case .success(let data):
            guard let data = data else { return }
            allContacts[index].thumbnail.state = .downloaded(data)
        case .failure(_):
            allContacts[index].thumbnail.state = .failed
        }
    }
    
    func filterContactList(_ searchString: String) -> [ContactPresentationModel] {
        filterString = searchString
        let filteredContacts = allContacts.filter({
            $0.fullname.lowercased().contains(searchString.lowercased())
        })
        filteringState = .filtered
        return filteredContacts
    }
}

enum ContactListFilteringState {
    case notFiltered
    case filtered
}
