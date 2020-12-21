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

final class Message: Model {
    
    typealias Input = _Input
    typealias Output = _Output

    static let schema = "message"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "contactID")
    var contactID: String
    
    @Field(key: "full_name")
    var fullName: String
    
    @Field(key: "avatar")
    var avatar: String
    
    @Field(key: "message")
    var message: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Parent(key: "chat_session_id")
    var chatSessionID: ChatSession
    
    init() {}
    
    init(id: UUID? = nil, contactID: String, fullName: String, avatar: String, message: String, chatSessionID: ChatSession.IDValue, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.contactID = contactID
        self.fullName = fullName
        self.avatar = avatar
        self.message = message
        self.$chatSessionID.id = chatSessionID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
