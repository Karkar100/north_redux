//
//  ImageState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 18.02.2023.
//

import Foundation
import ReSwift

struct Image {
    var state: ImageState
    
    init(state: ImageState) {
        self.state = state
    }
}

enum ImageState: Equatable {
    case notDownloaded
    case downloaded(Data)
    case failed
}

