import Vapor
import FluentPostgreSQL
import Authentication

struct SectionController: RouteCollection {
    
    // DEVSCORCH: Router function
    
    func boot(router: Router) throws {
        
        // DEVSCORCH: Section Router and sectionRouter  Handlers
        let sectionRoute = router.grouped("cataclysm", "courses", "sections")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = sectionRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        
        tokenAuthGroup.post(Section.self, use: createCourseSectionHandler)
        tokenAuthGroup.get(Section.parameter, use: getSectionHandler)
        tokenAuthGroup.get(Section.parameter, use: getCourseHandler)
        

        let basicMiddleWare = User.basicAuthMiddleware(using: BCryptDigest())
        let guardAuthMiddleWare = User.guardAuthMiddleware()
        let protected = sectionRoute.grouped(basicMiddleWare, guardAuthMiddleWare)
        protected.post(Section.self, use: createCourseSectionHandler)
        
    }
    
    // DEVSCORCH: Create Handler for creating course Sections
    func createCourseSectionHandler(_ req: Request, section: Section) throws -> Future<Section> {
        return try req.content.decode(Section.self).flatMap(to: Section.self) { section in
            return section.save(on: req)
        }
    }
    
    // DEVSCORCH: Get handler for getting sections
    func getSectionHandler(_ req: Request) throws -> Future<Section> {
        let _ = try req.parameters.next(Courses.self)
        return try req.parameters.next(Section.self)
    }
    
    // DEVSCORCH: Get Handler for getting Courses Sections
    func getCourseHandler(_ req: Request) throws ->  Future<Courses> {
        return try req.parameters.next(Section.self).flatMap(to: Courses.self) { section in
            section.courses.get(on: req)
        }
    }
    
}
