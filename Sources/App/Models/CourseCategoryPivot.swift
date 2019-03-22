import FluentPostgreSQL
import Foundation

final class CourseCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    
    var id: UUID?
    var courseID: Courses.ID
    var categoryID: Category.ID
    
    typealias Left = Courses
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \.courseID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ courses: Courses, _ category: Category) throws {
        self.courseID = try courses.requireID()
        self.categoryID = try category.requireID()
    }
}

extension CourseCategoryPivot: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.courseID, to: \Courses.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
}

