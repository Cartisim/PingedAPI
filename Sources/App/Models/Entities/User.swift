import Vapor
import Fluent

final class User: Model, Authenticatable {
    static let schema = "users"
    
    typealias Input = _Input
    typealias Output = _Output
    typealias ContactOutput = _ContactOutput
    typealias ChatSessionOutput = _ChatSessionOutput
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "full_name")
    var fullName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "is_email_verified")
    var isEmailVerified: Bool
    
    @Field(key: "public_key")
    var publicKey: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Siblings(through: UserChatSessionPivot.self, from: \.$user, to: \.$chatSession)
    var chatSession: [ChatSession]
    
    init() {}
    
    init(
        id: UUID? = nil,
        fullName: String,
        email: String,
        passwordHash: String,
        isAdmin: Bool = false,
        isEmailVerified: Bool = false,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
