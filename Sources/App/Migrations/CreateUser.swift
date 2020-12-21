import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("full_name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
            .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
            .field("public_key", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
