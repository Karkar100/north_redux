//
//  OneContactActions.swift
//  TelDir-redux
//
//  Created by Diana Princess on 27.02.2023.
//

import Foundation
import ReSwift

protocol OneContactAction: Action {}
enum OneContactActions: Action {
    case updateOneContact(UpdateOneContactAction)
    case updateImage(UpdateImageAction)
}

struct UpdateOneContactAction: OneContactAction {
    let id: String
}

struct UpdateImageAction: OneContactAction {
    let result: ImageDownloadingResult
}
