import Vapor
import Crypto
import Stripe


struct UserController: RouteCollection {
    func boot(router: Router) throws {
        
        let userRoute = router.grouped("cataclysm", "users")
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = userRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        let authsessionRoute = router.grouped(User.authSessionsMiddleware())
        
        userRoute.post(User.self, use: createHandler)
        tokenAuthGroup.get(use: getAllHandler)
        authsessionRoute.get(User.parameter, use: getHandler)
        authsessionRoute.put(User.parameter, use: updateHandler)
        authsessionRoute.post("logout", use: logoutHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = userRoute.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)
    }
    
    // DEVSCORCH: CreateHandler
    func createHandler(_ req: Request, user: User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        return user.save(on: req).convertToPublic()
    }
    
    // DEVSCORCH: GetAllHandler
    func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
        return User.query(on: req).decode(data: User.Public.self).all()
    }
    
    // DEVSCORCH: GetHandler
    func getHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(User.self).convertToPublic()
    }
    
    // DEVSCORCH: LoginHandler
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
    
    func logoutHandler(_ req: Request) throws -> Response {
        try req.unauthenticateSession(User.self)
        
        return req.redirect(to: "http://devsmenacademy.com")
    }

    
    
    // DEVSCORCH: UpdateHandler
    func updateHandler(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) {
            user, updatedUser in
            user.name = updatedUser.name
            user.stripeid  = updatedUser.stripeid
            user.subscription = updatedUser.subscription
            user.isActive = updatedUser.isActive
            user.email = updatedUser.email
            user.password = updatedUser.password
            return user.save(on: req)
        }
    }
}


