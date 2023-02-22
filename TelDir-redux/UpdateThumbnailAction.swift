//
//  SetImageDataAction.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

struct UpdateThumbnailAction: Action {
    let id: String
    let result: ImageDownloadingResult
}
