//
//  Middleware creator.swift
//  TelDir-redux
//
//  Created by Diana Princess on 20.02.2023.
//

import Foundation
import ReSwift

class MiddlewaresCreator {
    lazy var all: [Middleware<AppState>] = [getNetworkMiddleware()]
    static private let operationLimit = 20
    private lazy var imageDownloaderQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = Self.operationLimit
        return queue
    }()
    private lazy var operationStack = OperationStack(operationLimit: Self.operationLimit)
    private var imageDataCache: ImageDataCacheTypeProtocol
    init(imageDataCache: ImageDataCacheTypeProtocol) {
        self.imageDataCache = imageDataCache
    }
}

extension MiddlewaresCreator {
    func getNetworkMiddleware() -> Middleware<AppState> {
        return { dispatch, getState in
            return { next in
                return { action in
                    next(action)
                    guard let request = action as? HTTPRequestProtocol else { return }
                    switch request.dataType {
                    case .contacts:
                        self.processContactListRequest(request: request, dispatcher: dispatch)
                    case .imageData(let imageType):
                        self.processImageRequest(request: request, type: imageType, dispatcher: dispatch)
                    }
                }
            }
        }
    }
    
    func getNavigationMiddleware() -> Middleware<AppState> {
        return { dispatch, getState in
            return { next in
                return { action in
                    next(action)
                    guard let navigationChange = action as? RoutingActionProtocol else { return }
                    navigationChange.navigate(navigationChange.navigationState).forEach{ mainStore.dispatch($0) }
                }
            }
        }
    }
    
    private func processContactListRequest(request: HTTPRequestProtocol, dispatcher: @escaping DispatchFunction) {
        guard let url = URL(string: "\(request.resource)") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                if 200..<300 ~= statusCode && error == nil {
                    let correctResponse: ContactsNetworkResponse? = try? JSONDecoder().decode(ContactsNetworkResponse.self, from: data!)
                    let array = correctResponse?.results
                    let contacts = array?.map { self.createNewContactItem(contact: $0) }
                    request.receivedContacts(contacts: contacts ?? []).forEach{ mainStore.dispatch($0) }
                } else {
                    if let error = error {
                        request.onFailure(response: error).forEach{ mainStore.dispatch($0) }
                    }
                    if !(200...299).contains(statusCode) {
                        
                    }
                }
        }
        task.resume()
    }
    
    private func processImageRequest(request: HTTPRequestProtocol, type: RequestedImageType, dispatcher: @escaping DispatchFunction) {
        let imageData = imageDataCache.lookForImageData(for: request.resource)
        switch imageData {
            case .none:
            let imageDownloader = ImageDownloadingOperation(imageURLString: request.resource){ result in
                switch type {
                case .thumbnail(let id):
                    request.receivedImageData(result: result, id).forEach { mainStore.dispatch($0) }
                case .large:
                    request.receivedImageData(result: result, nil).forEach { mainStore.dispatch($0) }
                }
            }
            switch type {
            case .thumbnail:
                imageDownloaderQueue.addOperation(imageDownloader)
                operationStack.push(imageDownloader)
                operationStack.trimOperationsIfNeeded()
            case .large:
                imageDownloaderQueue.addOperation(imageDownloader)
            }
            case .some(let foundImageData):
                switch type {
                    case .thumbnail(let id):
                        request.receivedImageData(result: .success(foundImageData), id).forEach { mainStore.dispatch($0) }
                    case .large:
                    request.receivedImageData(result: .success(foundImageData), nil).forEach { mainStore.dispatch($0) }
                }
            return
        }
    }
    
    private func createNewContactItem(contact: OneContactNetworkResponse) -> ContactItem {
        let fullname = contact.name.first+" "+contact.name.last
        let largeImageStr = contact.picture.large
        return ContactItem(fullname: fullname, email: contact.email, phone: contact.phone, cell: contact.cell, largeImageStr: largeImageStr, nat: contact.nat, thumbnailString: contact.picture.thumbnail)
    }
}

