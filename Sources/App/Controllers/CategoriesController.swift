import Vapor
import Authentication


struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("cataclysm", "categories")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = categoriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post(Category.self, use: createHandler)
        tokenAuthGroup.delete(Category.parameter, use: deleteHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.get(Category.parameter, "courses", use: getCoursesHandler)
        
        tokenAuthGroup.post(Category.self, use: createHandler)
        
    }
    
    // DEVSCORCHL Categories Handler for creation of Categories
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    // DEVSCORCH: Categories Handler for retrieving Categories
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    // DEVSCORCH: Categories Handler for retrieving one specific Category
    func getHandler(_ req: Request) throws -> Future<Category> {
       return try req.parameters.next(Category.self)
    }
    
    // DEVSCORCH: Handler for retrieving specific Courses in a Category
    func getCoursesHandler(_ req: Request) throws -> Future<[Courses]> {
        return try req.parameters.next(Category.self).flatMap(to: [Courses].self) { category in
            try category.courses.query(on: req).all()
        }
    }
    
    func deleteHandler(_ req: Request)  throws -> Future<HTTPStatus> {
        return try req.parameters.next(Category.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}
