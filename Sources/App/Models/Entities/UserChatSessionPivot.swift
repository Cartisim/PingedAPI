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

final class UserChatSessionPivot: Model {
    // Name of the table or collection.
    static let schema: String = "user_chat_session"

    // Unique identifier for this pivot.
    @ID(key: .id)
    var id: UUID?

    // Reference to the Tag this pivot relates.
    @Parent(key: "user_id")
    var user: User

    // Reference to the Star this pivot relates.
    @Parent(key: "chat_session_id")
    var chatSession: ChatSession

    // Creates a new, empty pivot.
    init() {}

    // Creates a new pivot with all properties set.
    init(userID: UUID, chatSessionID: UUID) {
        self.user.id = userID
        self.chatSession.id = chatSessionID
    }

}
