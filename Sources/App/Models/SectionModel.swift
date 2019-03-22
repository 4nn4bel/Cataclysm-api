import Vapor
import FluentPostgreSQL

final class Section: Codable {
    var id: Int?
    var sectionName: String
    var lectures: Int
    var level: String
    var courseID: Courses.ID

    
    init(id: Int, sectionName: String, lectures: Int, level: String, courseID: Courses.ID) {
        self.id = id
        self.sectionName = sectionName
        self.lectures = lectures
        self.level = level
        self.courseID = courseID
    }
}

extension Section: Migration {}
extension Section: PostgreSQLModel {}
extension Section: Content {}
extension Section: Parameter {}

extension Section {
    var courses: Parent<Section, Courses> {
        return parent(\.courseID)
    }
}

extension Section {
    var videos: Children<Section, VideoModel> {
        return children(\.sectionID)
    }
}
