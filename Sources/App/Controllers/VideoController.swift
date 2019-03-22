import Vapor
import Fluent
import Authentication

struct VideoController: RouteCollection {
    func boot(router: Router) throws {
        let videoRoute = router.grouped("cataclysm", "courses", "sections", "videos")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = videoRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post(VideoModel.self, use: createVideoHandler)
        tokenAuthGroup.get(VideoModel.parameter, use: getVideoHandler)
        tokenAuthGroup.get(use: getAllVideoHandler)
    }
    
    func createVideoHandler(_ req: Request, video: VideoModel) throws -> Future<VideoModel> {
        return try req.content.decode(VideoModel.self).flatMap(to: VideoModel.self) { video in
            return video.save(on: req)
        }
    }
    
    func getVideoHandler(req: Request) throws -> Future<Section> {
        let user = try req.requireAuthenticated(User.self)
        if user.isActive == true {
            return try req.parameters.next(VideoModel.self).flatMap(to: Section.self) { video in
               return video.section.get(on: req)
            }
        } else {
            throw Abort(.badRequest, reason: "You dont have a active subscription. Make sure to activate a subscription plan and try again")
        }
    }
    
    func getAllVideoHandler(_ req: Request) throws -> Future<[VideoModel]> {
        return VideoModel.query(on: req).all()
    }
}


