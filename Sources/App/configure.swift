import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first.
    try services.register(FluentSQLiteProvider())
    
    // Define Hostname & Port to listen to.
    let myServerConfig = NIOServerConfig.default(hostname: "localhost", port: 8100)
    services.register(myServerConfig)

    // Register routes to the router.
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware.
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database.
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    // Register migration services.
    var migrations = MigrationConfig()
    migrations.add(model: Book.self, database: DatabaseIdentifier<Book.Database>.sqlite)
    services.register(migrations)
        
    // Command Configuration.
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
