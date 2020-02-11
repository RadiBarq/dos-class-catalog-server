//
//  BookAvailableRequest.swift
//  App
//
//  Created by Harri on 2/9/20.
//

import Foundation
import Vapor

/// BookAvailableResponse
final class BookAvailableResponse {
    
    var available: Bool
    
    init(available: Bool) {
        self.available = available
    }
}

/// Allows `BookAvailableResponse` to be encoded to and decoded from HTTP messages.
extension BookAvailableResponse: Content {}
