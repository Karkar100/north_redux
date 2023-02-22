//
//  ImageDataCacheTypeProtocol.swift
//  TelDir-redux
//
//  Created by Diana Princess on 18.02.2023.
//

import Foundation
import UIKit
protocol ImageDataCacheTypeProtocol: AnyObject {
    func lookForImageData(for urlString: String) -> Data?
    func insertImageData(_ data: Data?, for urlString: String)
}

