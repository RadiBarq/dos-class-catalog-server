import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Create new book
    router.post("books") { req -> Future<Book> in
        return try req.content.decode(Book.self)
            .flatMap(to: Book.self) { book in
                return book.save(on: req)
        }
    }
    
    // Retreive all books
    router.get("books") { req -> Future<[Book]> in
        return Book.query(on: req).all()
    }
    
    // Retreive single book
    router.get("books", Book.parameter) { req -> Future<Book> in
        return try req.parameters.next(Book.self)
    }
    
    // Update 'Book' information
    router.put("books", Book.parameter) {
        req -> Future<Book> in
        return try flatMap(to: Book.self, req.parameters.next(Book.self), req.content.decode(Book.self)) {
            book, updtedBook in
            book.price = updtedBook.price
            book.numberOfItems = updtedBook.numberOfItems
            return book.save(on: req)
        }
    }
    
    // Update 'Book' number of items
    router.put("books", "number-of-items", Book.parameter) {
          req -> Future<Book> in
          return try flatMap(to: Book.self, req.parameters.next(Book.self), req.content.decode(Book.self)) {
              book, updtedBook in
              book.numberOfItems = updtedBook.numberOfItems
              return book.save(on: req)
          }
    }
    
    // Delete 'Book' information
    router.delete("books", Book.parameter) {
        req -> Future<HTTPStatus> in
        return try req.parameters.next(Book.self)
            .delete(on: req)
            .transform(to: .noContent)
    }
    
    // Search books by 'Cateogry'
    router.get("books", "search") {
        req -> Future<[Book]> in
        guard let searchCategory = req.query[String.self, at: "category"] else {
                throw Abort(.badRequest)
        }
        return Book.query(on: req)
            .filter(\.category == searchCategory)
            .all()
    }
    
    // Check if book available or not
    router.get("books", "available", Book.parameter) { req -> Future<BookAvailableResponse> in
        return try req.parameters.next(Book.self)
            .flatMap(to: BookAvailableResponse.self) { book in
                return req.future(BookAvailableResponse(available: book.numberOfItems != 0, book: book))
        }
    }
}
