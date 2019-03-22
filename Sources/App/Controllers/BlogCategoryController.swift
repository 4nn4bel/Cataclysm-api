import Vapor

struct BlogCategorieController: RouteCollection {
    func boot(router: Router) throws {
        let blogCategoryRoute = router.grouped("cataclysm", "blog", "Categories")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = blogCategoryRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post(BlogCategory.self, use: createHandler)
        tokenAuthGroup.put(BlogCategory.parameter, use: updateHandler)
        blogCategoryRoute.get(use: getAllHandler)
        blogCategoryRoute.get(BlogCategory.parameter, use: getHandler)
        
    }
    
    //DEVSCORCH: BlogCategory Create Handler
    func createHandler(_ req: Request, blogCategory: BlogCategory) throws -> Future<BlogCategory> {
        return blogCategory.save(on: req)
    }
    
    // DEVSCORCH: BlogCategory GetAllHandler
    func getAllHandler(_ req: Request) throws -> Future<[BlogCategory]> {
        return BlogCategory.query(on: req).all()
    }
    
    // DEVSCORCH: BlogCategory Get Handler
    func getHandler(_ req: Request) throws -> Future<BlogCategory> {
        return try req.parameters.next(BlogCategory.self)
    }
    
    // DEVSCORCH: BlogCategory updateHandler
    func updateHandler(_ req: Request) throws -> Future<BlogCategory> {
        return try flatMap(to: BlogCategory.self, req.parameters.next(BlogCategory.self), req.content.decode(BlogCategory.self)) {
            blogCategory, updatedBlogCategory in
            blogCategory.name = updatedBlogCategory.name
            return blogCategory.save(on: req)
        }
    }
}
