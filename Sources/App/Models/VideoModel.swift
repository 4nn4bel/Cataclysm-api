import Vapor
import FluentPostgreSQL

final class VideoModel: Codable {
    var id: Int?
    var videoName: String
    var videoURL: URL
    var sectionID: Section.ID
    
    init(videoName: String, videoURL: URL, sectionID: Section.ID) {
        self.videoName = videoName
        self.videoURL = videoURL
        self.sectionID = sectionID
        
    }
}

extension VideoModel: PostgreSQLModel {}
extension VideoModel: Migration {}
extension VideoModel: Content {}
extension VideoModel: Parameter {}

extension VideoModel {
    var section: Parent<VideoModel, Section> {
        return parent(\.sectionID)
    }
}
