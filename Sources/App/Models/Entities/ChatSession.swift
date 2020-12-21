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

final class ChatSession: Model {
    
    typealias Input = _Input
    typealias Output = _Output
    typealias EagerOutput = _EagerOutput

    static let schema = "chat_session"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "contactID")
    var contactID: String
    
    @Field(key: "fullName")
    var fullName: String
    
    @Field(key: "publicKey")
    var publicKey: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$chatSessionID)
    var message: [Message]
    
    @Siblings(through: UserChatSessionPivot.self, from: \.$chatSession, to: \.$user)
    var user: [User]
    
    init() {}
    
    init(id: UUID? = nil, contactID: String, fullName: String, publicKey: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.contactID = contactID
        self.fullName = fullName
        self.publicKey = publicKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
