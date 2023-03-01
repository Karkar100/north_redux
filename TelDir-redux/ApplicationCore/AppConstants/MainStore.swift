//
//  ApplicationStore.swift
//  TelDir-redux
//
//  Created by Diana Princess on 16.02.2023.
//

import Foundation
import ReSwift

let imageDataCache = ImageDataCache()
let middlewaresCreator = MiddlewaresCreator(imageDataCache: imageDataCache)
let mainStore = Store<AppState>(
    reducer: Reducers.appReducer,
    state: nil,
    middleware: [
        middlewaresCreator.getNetworkMiddleware(),
        middlewaresCreator.getNavigationMiddleware()
    ]
)
