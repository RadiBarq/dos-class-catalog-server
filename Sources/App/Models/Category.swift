//
//  Category.swift
//  App
//
//  Created by Harri on 2/8/20.
//

import FluentSQLite
import Vapor

/// Category
final class Category {
 
    // Id
    var id: Int?
    
    // Title
    var title: String
 
    // Creates new 'Category'
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Category: Content {}

extension Category: SQLiteModel {}

extension Category: Migration {}
