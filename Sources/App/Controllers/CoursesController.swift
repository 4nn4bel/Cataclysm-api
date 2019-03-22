import Vapor
import Fluent
import Authentication

struct CourseController: RouteCollection {
    
    // DEVSCORCH: Courses Router Handler
    
    func boot(router: Router) throws {
        
        // DEVSCORCH: Courses Router Handlers
        
        let coursesRoute = router.grouped("cataclysm", "courses")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = coursesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        coursesRoute.get(use: getAllHandler)
        coursesRoute.get("search", use: searchHandler)
        coursesRoute.get(Courses.parameter, use: getHandler)
        tokenAuthGroup.post(Courses.parameter, "categories", Category.parameter, use: addCategoryHandler)
        coursesRoute.get("categories", use: getAllHandler)
        tokenAuthGroup.get(Courses.parameter, "sections", use: getAllSectionHandler)
        tokenAuthGroup.get(Courses.parameter, "sections", Section.parameter, use: getSectionHandler)
        
        tokenAuthGroup.get(Courses.parameter, "sections", Section.parameter, "videos", use: getAllVideoHandler)
        tokenAuthGroup.get(Courses.parameter, "sections", Section.parameter, "videos", VideoModel.parameter, use: getVideoHandler)
        
        // DEVSCORCH: Guarded the Course Section so only Registered users can do stuff
        
        tokenAuthGroup.post(Courses.self, use: createHandler)
    }
    
    // DEVSCORCH: Course CreateHandler
    func createHandler(_ req: Request, course: Courses) throws -> Future<Courses> {
        return try req.content.decode(Courses.self).flatMap(to: Courses.self) { courses in
            return courses.save(on: req)
        }
    }
    
    // DEVSCORCH: Course getHandler
    func getHandler(_ req: Request) throws -> Future<Courses> {
        return try req.parameters.next(Courses.self)
    }
    
    // DEVSCORCH: Course CreateHandler
    func getAllHandler(_ req: Request) throws -> Future<[Courses]> {
        return Courses.query(on: req).all()
    }
    
    // DEVSCORCH: Course SearchHandler
    func searchHandler(_ req: Request) throws -> Future<[Courses]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Courses.query(on: req).group(.or) { or in
            or.filter(\.courseName == searchTerm)
            or.filter(\.courseType == searchTerm)
            or.filter(\.instructor == searchTerm)
        }.all()
    }
    
    // DEVSCORCH: Course UpdateHandler
    func updateHandler(_ req: Request) throws -> Future<Courses> {
        return try flatMap(to:Courses.self, req.parameters.next(Courses.self), req.content.decode(Courses.self)) {
            courses, updatedCourse in
            courses.courseName = updatedCourse.courseName
            courses.instructor = updatedCourse.instructor
            courses.courseDescription = updatedCourse.courseDescription
            courses.videoCount = updatedCourse.videoCount
            courses.courseIntro = updatedCourse.courseIntro
            courses.courseType = updatedCourse.courseType
            courses.courseImage = updatedCourse.courseImage
            return courses.save(on: req)
        }
    }
    
    
    // DEVSCORCH: Category CreateHandler
    func addCategoryHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Courses.self), req.parameters.next(Category.self)) { courses, category in
            return courses.categories.attach(category, on: req).transform(to: .created)
        }
    }
    
    // DEVSCORCH: Category Course Handlers
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
        return try req.parameters.next(Courses.self).flatMap(to: [Category].self) { courses in
            try courses.categories.query(on: req).all()
        }
    }
    
    // DEVSCORCH: Handler for retrieving all sections in a Course
    func getAllSectionHandler(_ req: Request) throws -> Future<[Section]> {
        return try req.parameters.next(Courses.self).flatMap(to: [Section].self) { courses in
            try courses.section.query(on: req).all()
        }
    }
    
    // DEVSCORCH: Handler for retrieving one section in a Course
    func getSectionHandler(_ req: Request) throws -> Future<Section> {
        let _ = try req.parameters.next(Courses.self)
        return try req.parameters.next(Section.self)
    }
    
    // DEVSCORCH: Handler for retrieving Videos from Sections
    
    func getAllVideoHandler(_ req: Request) throws -> Future<[VideoModel]> {
        let _ = try req.parameters.next(Courses.self)
        return try req.parameters.next(Section.self).flatMap(to: [VideoModel].self) { videos in
            return VideoModel.query(on: req).all()
        }
    }
    
    func getVideoHandler(req: Request) throws -> Future<VideoModel> {
        let _ = try req.parameters.next(Courses.self)
        let _ = try req.parameters.next(Section.self)
        return try req.parameters.next(VideoModel.self)
    }
    
}
