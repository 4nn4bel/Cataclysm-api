import Vapor
import Leaf
import Stripe


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    
    let userController = UserController()
    let courseController = CourseController()
    let categoriesController = CategoriesController()
    let websiteController = WebController()
    let videoController = VideoController()
    let sectionController = SectionController()
    let blogController = BlogController()
    let blogCategoriesController = BlogCategorieController()
    
    try router.register(collection: userController)
    try router.register(collection: courseController)
    try router.register(collection: categoriesController)
    try router.register(collection: websiteController)
    try router.register(collection: videoController)
    try router.register(collection: sectionController)
    try router.register(collection: blogController)
    try router.register(collection: blogCategoriesController)
    
    
    
}
