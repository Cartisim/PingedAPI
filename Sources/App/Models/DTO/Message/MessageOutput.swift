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

extension Message {
    struct _Output: Content {
        var id: String
        var contactID: String
        var fullName: String
        var avatar: String
        var message: String
        var updatedAt: Date
        var createdAt: Date
        
        init(id: String, contactID: String, fullName: String, avatar: String, message: String, updatedAt: Date, createdAt: Date) {
            self.id = id
            self.contactID = contactID
            self.fullName = fullName
            self.avatar = avatar
            self.message = message
            self.updatedAt = updatedAt
            self.createdAt = createdAt
        }
        
        init(from message: Message) {
            self.init(id: message.id!.uuidString, contactID: message.contactID, fullName: message.fullName, avatar: message.avatar, message: message.message, updatedAt: message.updatedAt ?? Date(), createdAt: message.createdAt ?? Date())
        }
    }
}



