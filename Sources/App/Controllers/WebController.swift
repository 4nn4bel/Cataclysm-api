import Vapor
import Leaf
import Authentication

struct WebController: RouteCollection {
    func boot(router: Router) throws {
        
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())
        
        authSessionRoutes.post(LoginPostData.self, at: "cataclysm", "login", use: loginPostHandler)
        authSessionRoutes.get("cataclysm", "login", use: loginHandler)
        
    }
    
    // DEVSCORCH: Handler of login in a user
    func loginHandler(_ req: Request) throws -> Future<View> {
        let context: LoginContext
        if req.query[Bool.self, at: "error"] != nil {
            context = LoginContext(loginError: true)
        } else {
            context = LoginContext()
        }
        return try req.view().render("login", context)
    }
    
    
    // DEVSCORCH: Handler for the LoginPost request
    func loginPostHandler(_ req: Request, userData: LoginPostData) throws -> Future<Response> {
        return User.authenticate(username: userData.username, password: userData.password, using: BCryptDigest(), on: req).map(to: Response.self) { user in
            guard let user = user else {
                return req.redirect(to: "/login?error")
            }
            try req.authenticateSession(user)
            return req.redirect(to: "/var/www/html/index.nginx-debian.html")
        }
    }
}

// DEVSCORCH: Login Context
struct LoginContext: Encodable {
    let title = "Login"
    let loginError: Bool
    
    init(loginError: Bool = false) {
        self.loginError = loginError
    }
}

// DEVSCORCH: Login Post Data
struct LoginPostData: Content {
    let username: String
    let password: String
}
