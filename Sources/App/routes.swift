import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    /// Registers routes to the incoming add book requests.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The added book
    router.post("books") { req -> Future<Book> in
        return try req.content.decode(Book.self)
            .flatMap(to: Book.self) { book in
                return book.save(on: req)
        }
    }
    
    /// Registers routes to the incoming add book requests.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The added book
    router.get("books") { req -> Future<[Book]> in
        return Book.query(on: req).all()
    }
    
    /// Registers routes to the incoming get book requests.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The asked book.
    router.get("books", Book.parameter) { req -> Future<Book> in
        return try req.parameters.next(Book.self)
    }
    
    /// Registers routes to the update book requests.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The book after been udpated.
    router.put("books", Book.parameter) {
        req -> Future<Book> in
        return try flatMap(to: Book.self, req.parameters.next(Book.self), req.content.decode(Book.self)) {
            book, updtedBook in
            book.price = updtedBook.price
            book.numberOfItems = updtedBook.numberOfItems
            return book.save(on: req)
        }
    }
    
    /// Registers routes to update the book number of items.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The book after been updated.
    router.put("books", "number-of-items", Book.parameter) {
          req -> Future<Book> in
          return try flatMap(to: Book.self, req.parameters.next(Book.self), req.content.decode(Book.self)) {
              book, updtedBook in
              book.numberOfItems = updtedBook.numberOfItems
              return book.save(on: req)
          }
    }
    
    /// Registers routes to delete the book.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The http status of the request.
    router.delete("books", Book.parameter) {
        req -> Future<HTTPStatus> in
        return try req.parameters.next(Book.self)
            .delete(on: req)
            .transform(to: .noContent)
    }
    
    /// Registers routes to search book request.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The books that searched.
    router.get("books", "search") {
        req -> Future<[Book]> in
        guard let searchCategory = req.query[String.self, at: "category"] else {
                throw Abort(.badRequest)
        }
        return Book.query(on: req)
            .filter(\.category == searchCategory)
            .all()
    }

    /// Registers routes to check if book available or not.
    ///
    /// - parameters:
    ///     - path: Variadic `PathComponentsRepresentable` items.
    ///     - closure: Creates a `Response` for the incoming `Request`.
    /// - returns: The book available response to check if the book available or not.
    router.get("books", "available", Book.parameter) { req -> Future<BookAvailableResponse> in
        return try req.parameters.next(Book.self)
            .flatMap(to: BookAvailableResponse.self) { book in
                return req.future(BookAvailableResponse(available: book.numberOfItems != 0, book: book))
        }
    }
}
