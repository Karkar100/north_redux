//
//  OneContactState.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import Foundation
import ReSwift

struct OneContactState {
    var image: Image
    var contactInfoOptions: ContactInfoOptions
    var additionalScreen: AdditionalScreens
}

enum ContactInfoOptions {
    case initial
    case updated(ContactDetailedInfo)
}

enum AdditionalScreens {
    case none
    case largePhoto
    case sms
}
