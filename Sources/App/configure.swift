import FluentPostgreSQL
import Vapor
import Authentication
import Leaf
import Stripe
import Foundation



/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    /// Register providers first
    
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    try services.register(LeafProvider())
    try services.register(StripeProvider())

    // DEVSCORCH: RouterSetup
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // DEVSCORCH: MiddleWare

    var middlewares = MiddlewareConfig()
    let corsConfiguration = CORSMiddleware.Configuration(allowedOrigin: .all, allowedMethods: [.POST, .GET, .PUT, .OPTIONS, .DELETE, .PATCH], allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    middlewares.use(corsMiddleware)
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    // DEVSCORCH: Database configuration
    
    var databases = DatabasesConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(
    
        hostname: "",
        username: "",
        database: "",
        password: ""
    )
    
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)

    services.register(databases)
    
    // DEVSCORCH: Migrations
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Courses.self, database: .psql)
    migrations.add(model: Section.self, database: .psql)
    migrations.add(model: VideoModel.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: CourseCategoryPivot.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(model: BlogModel.self, database: .psql)
    migrations.add(model: BlogCategory.self, database: .psql)
    migrations.add(model: BlogCategoryPivot.self, database: .psql)
    services.register(migrations)
    
    // Caching
    
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
