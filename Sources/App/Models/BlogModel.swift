import FluentPostgreSQL
import Vapor


final class BlogModel: Codable {
    
    var id: Int?
    var title: String
    var background: String
    var date: String
    var writer: String
    var intro: String
    var post: String
    
    init(title: String, background: String, date: String, writer: String, intro: String, post: String) {
        self.title = title
        self.background = background
        self.date = date
        self.writer = writer
        self.intro = intro
        self.post = post
    }
}

extension BlogModel: PostgreSQLModel {}
extension BlogModel: Migration {
    var blogCategories: Siblings<BlogModel, BlogCategory, BlogCategoryPivot> {
        return siblings()
    }
    
}
extension BlogModel: Parameter {}
extension BlogModel: Content {}







