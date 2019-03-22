import Vapor
import FluentPostgreSQL
import Foundation
import Authentication
import Fluent

final class Courses: Codable {
    var id: UUID?
    var courseName: String
    var instructor: String
    var courseDescription: String
    var videoCount: Int
    var courseIntro: URL
    var courseType: String
    var courseImage: String?
    
    init(courseName: String, courseDescription: String, videoCount: Int, courseIntro: URL, courseType: String, instructor: String, courseImage: String) {
        self.courseName = courseName
        self.courseDescription = courseDescription
        self.videoCount = videoCount
        self.courseIntro = courseIntro
        self.courseType = courseType
        self.instructor = instructor
        self.courseImage = courseImage
    }
}

extension Courses: PostgreSQLUUIDModel {}
extension Courses: Migration {
    var categories: Siblings<Courses, Category, CourseCategoryPivot> {
        return siblings()
    }
}

extension Courses: Content {}
extension Courses: Parameter {}

extension Courses {

    var section: Children<Courses, Section> {
        return children(\.courseID)
    }
}



