//
//  HTTPRequest.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation
import ReSwift

class HTTPRequest: Action {
    let resource: String
    let method: HTTPMethod
    let dataType: RequestedDataType
    
    init(resource: String = "https://randomuser.me/api/?results=1000&inc=name,phone,cell,email,nat,picture", method: HTTPMethod, dataType: RequestedDataType) {
        self.resource = resource
        self.method = method
        self.dataType = dataType
    }
}

// MARK: HTTPRequest protocol implementation
extension HTTPRequest: HTTPRequestProtocol {
    func receivedContacts(contacts: [ContactItem]) -> [Action] {
        return [ContactListTransformAction(source: contacts)]
    }
    
    func receivedImageData(result: ImageDownloadingResult, _ id: String? = nil) -> [Action] {
        if id != nil {
            return [UpdateThumbnailAction(id: id!, result: result)]
        } else {
            return [UpdateImageAction(result: result)]
        }
    }
    
    func onFailure(response: Error) -> [Action] {
        return [DisplayErrorAction(error: response)]
    }
}
