//
//  HTTPRequestProtocol.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation
import ReSwift
 
enum HTTPMethod: String {
    case get = "GET"
}

enum RequestedDataType {
    case contacts
    case imageData(RequestedImageType)
}

enum RequestedImageType {
    case thumbnail(String)
    case large
}

protocol HTTPRequestProtocol {
    var resource: String { get }
    var method: HTTPMethod { get }
    var dataType: RequestedDataType { get }
    
    func receivedContacts(contacts: [ContactItem]) -> [Action]
    func receivedImageData(result: ImageDownloadingResult, _ id: String?) -> [Action]
    func onFailure(response: Error) -> [Action]
}
