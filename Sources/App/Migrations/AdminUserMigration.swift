//MIT License
//
//Copyright (c) [2020] [Cartisim Development]
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Vapor
import Fluent

struct AdminUser: Migration {
    let config: AppConfig
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let registerAdminRequest = RegisterAdminRequest(fullName: config.adminName, email: config.adminEmail, password: config.adminPassword, confirmPassword: config.adminPassword, isAdmin: true, isEmailVerified: true)
                let hashed =  try? Bcrypt.hash(registerAdminRequest.confirmPassword)
                guard let hashedPassword = hashed else {
                    fatalError("Failed to create admin user")
                }
        let user = try? User(from: registerAdminRequest, hash: hashedPassword)
                return (user?.save(on: database).transform(to: ()))!
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return  database.schema("admin_user").delete()
    }
          var name: String { "AdminUser" }
}
