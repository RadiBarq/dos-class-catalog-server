//
//  BookAvailableRequest.swift
//  App
//
//  Created by Harri on 2/9/20.
//

import Foundation
import Vapor

/// Book Available Response.
final class BookAvailableResponse {
    
    /// Available.
    var available: Bool
    
    /// Book.
    var book: Book
    
    /// Create `BookAvailableResponse`.
    init(available: Bool, book: Book) {
        self.available = available
        self.book = book
    }
}

/// Allows `BookAvailableResponse` to be encoded to and decoded from HTTP messages.
extension BookAvailableResponse: Content {}
