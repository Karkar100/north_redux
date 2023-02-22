//
//  File.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation

public enum HTTPError: Error{
    case transportError(Error)
    case httpError(Int)
}
