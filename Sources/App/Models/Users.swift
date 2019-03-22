import Vapor
import Foundation
import FluentPostgreSQL
import Authentication


final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    var email: String
    var password: String
    var userImage: String?
    var stripeid: String!
    var videoWatched: [Int]?
    var coursesFollowed: [String]?
    var isActive: Bool? = false
    var subscription: String?
    var dateJoined: Date?
    
    
    init(email: String, username: String, name: String, password: String, userImage: String, stripeid: String, videoWatched: [Int], coursesFollowed: [String], isActive: Bool, subscription: String, dateJoined: Date) {
        self.email = email
        self.username = username
        self.name = name
        self.password = password
        self.userImage = userImage
        self.stripeid = stripeid
        self.videoWatched = videoWatched
        self.coursesFollowed = coursesFollowed
        self.isActive = isActive
        self.subscription = subscription
        self.dateJoined = dateJoined
    }
    
    final class Public: Codable {
        var id: UUID?
        var name: String
        var username: String
        var email: String
        
        init(id: UUID, name: String, username: String, email: String) {
            self.name = name
            self.id = id
            self.username = username
            self.email = email
        }
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) {
            builder in
                try addProperties(to: builder)
            builder.unique(on: \.username)
            builder.unique(on: \.email)
        }
    }
}

extension User: Parameter {}
extension User.Public: Content {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id!, name: name, username: username, email: email)
    }
}

extension Future where T: User {
    func convertToPublic() -> Future<User.Public> {
        return self.map(to: User.Public.self) { user in
            return user.convertToPublic()
        }
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}

extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}
