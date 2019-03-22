import FluentPostgreSQL
import Foundation

final class BlogCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    var id: UUID?
    var blogID: BlogModel.ID
    var blogCategoryID: BlogCategory.ID
    
    typealias Left = BlogModel
    typealias Right = BlogCategory
    
    static let leftIDKey: LeftIDKey = \.blogID
    static let rightIDKey: RightIDKey = \.blogCategoryID
    
    init(_ blogModel: BlogModel, _ blogCategory: BlogCategory) throws {
        self.blogID = try blogModel.requireID()
        self.blogCategoryID = try blogCategory.requireID()
    }
}

extension BlogCategoryPivot: Migration {}
