import Vapor
import FluentPostgreSQL

final class BlogCategory: Codable {
    var id: Int?
    var name: String
    
    
    init(name: String) {
        self.name = name
    }
}

extension BlogCategory: PostgreSQLModel {}
extension BlogCategory: Content {}
extension BlogCategory: Migration {}
extension BlogCategory: Parameter {}
