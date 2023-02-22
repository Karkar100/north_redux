//
//  ContactPresentationModel.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation

struct ContactPresentationModel {
    let fullname: String
    let thumbnailString: String
    var thumbnail: Image
    let id: String
}

extension ContactPresentationModel: Hashable {
    static func == (lhs: ContactPresentationModel, rhs: ContactPresentationModel) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
