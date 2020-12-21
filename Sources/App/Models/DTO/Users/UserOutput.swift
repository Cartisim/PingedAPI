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

extension User {
    struct _Output: Content {
        let id: UUID?
        let fullName: String
        let email: String
        let isAdmin: Bool
        var updatedAt: Date?
        var createdAt: Date?
        
        init(id: UUID? = nil, fullName: String, email: String, isAdmin: Bool, updatedAt: Date? = nil, createdAt: Date? = nil) {
            self.id = id
            self.fullName = fullName
            self.email = email
            self.isAdmin = isAdmin
            self.updatedAt = updatedAt
            self.createdAt = createdAt
        }
        
        init(from user: User) {
            self.init(id: user.id, fullName: user.fullName, email: user.email, isAdmin: user.isAdmin, updatedAt: user.updatedAt, createdAt: user.createdAt)
        }
    }
}

extension User {
    struct _ChatSessionOutput: Content {
        var id: String
        var fullName: String
        var chatSession: [ChatSession]
        var updatedAt: Date?
        var createdAt: Date?
        
        init(id: String, fullName: String, chatSession: [ChatSession], updatedAt: Date? = nil, createdAt: Date? = nil) {
            self.id = id
            self.fullName = fullName
            self.chatSession = chatSession
            self.updatedAt = updatedAt
            self.createdAt = createdAt
        }
        
        init(from user: User) {
            self.init(id: user.id!.uuidString, fullName: user.fullName, chatSession: user.chatSession, updatedAt: user.updatedAt, createdAt: user.createdAt)
        }
        
    }
}

extension User {
    struct _ContactOutput: Content {
        var id: String
        var fullName: String
        var publicKey: String
        var updatedAt: Date?
        var createdAt: Date?
        
        init(id: String, fullName: String, publicKey: String, updatedAt: Date? = nil, createdAt: Date? = nil) {
            self.id = id
            self.fullName = fullName
            self.publicKey = publicKey
            self.updatedAt = updatedAt
            self.createdAt = createdAt
        }
        
        init(from user: User) {
            self.init(id: user.id!.uuidString, fullName: user.fullName, publicKey: user.publicKey ?? "", updatedAt: user.updatedAt, createdAt: user.createdAt)
        }
        
    }
}
