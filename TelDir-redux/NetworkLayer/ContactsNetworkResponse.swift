//
//  ContactsNetworkResponse.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation
struct ContactsNetworkResponse: Codable {
    var results: [OneContactNetworkResponse]?
    var error: String?
}

struct OneContactNetworkResponse: Codable{
    var name: UserNameResponse
    var email: String
    var phone: String
    var cell: String
    var picture: PictureOptionsResponse
    var nat: String
}

struct UserNameResponse: Codable {
    var title: String
    var first: String
    var last: String
}

struct PictureOptionsResponse: Codable {
    var large: String
    var medium: String
    var thumbnail: String
}
