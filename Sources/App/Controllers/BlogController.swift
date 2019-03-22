import Vapor
import Authentication

struct BlogController: RouteCollection {
    func boot(router: Router) throws {
        //
        
        let blogRoute = router.grouped("cataclysm", "blog")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = blogRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post(BlogModel.self, use: createHandler)
        tokenAuthGroup.put(BlogModel.parameter, use: updateHandler)
        tokenAuthGroup.post(BlogModel.parameter, "categories", BlogCategory.parameter, use: addCategoriesHandler)
        tokenAuthGroup.delete(BlogModel.parameter, use: deleteHandler)
        blogRoute.get(BlogModel.parameter, use: getBlogHandler)
        blogRoute.get(use: getAllBlogHandler)
        
    }
    
    
    // DEVSCORCH: Blog Creation Handler
    func createHandler(_ req: Request, blogmodel: BlogModel) throws -> Future<BlogModel> {
        return blogmodel.save(on: req)
    }
    
    // DEVSCORCH: Blog Get Handler
    func getBlogHandler(_ req: Request) throws -> Future<BlogModel> {
        return try req.parameters.next(BlogModel.self)
    }
    
    // DEVSCORCH Get All Blog Handler
    func getAllBlogHandler(_ req: Request) throws -> Future<[BlogModel]> {
        return BlogModel.query(on: req).all()
    }
    
    //DEVSCORCH: Deletion Blog Handler
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(BlogModel.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    // DEVSCORCH: Blog Update handler
    func updateHandler(_ req: Request) throws -> Future<BlogModel> {
        return try flatMap(to: BlogModel.self, req.parameters.next(BlogModel.self), req.content.decode(BlogModel.self)) {
            blogmodel, updatedBlogModel in
            blogmodel.title = updatedBlogModel.title
            blogmodel.background = updatedBlogModel.background
            blogmodel.intro = updatedBlogModel.intro
            blogmodel.writer = updatedBlogModel.writer
            blogmodel.post = updatedBlogModel.post
            return blogmodel.save(on: req)
        }
    }
    
    
    
    // DEVSCORCH: Add Category Handler
    func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(BlogModel.self), req.parameters.next(BlogCategory.self)) { blogmodel, blogCategory in
            return blogmodel.blogCategories.attach(blogCategory, on: req).transform(to: .created)
        }
    }
    
    // DEVSCORCH: Get categories Handler
    func getCategoriesHandler(_ req: Request) throws -> Future<[BlogCategory]> {
        return try req.parameters.next(BlogModel.self).flatMap(to: [BlogCategory].self) { blogmodel in
            try blogmodel.blogCategories.query(on: req).all()
        }
    }
    
    
    
    
    
}


