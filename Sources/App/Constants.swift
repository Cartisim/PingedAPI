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

struct Constants {
    static let shared = Constants()
    
    
    /// How long should access tokens live for. Default: 15 minutes (in seconds)
    static let ACCESS_TOKEN_LIFETIME: Double = 60 * 15
    /// How long should refresh tokens live for: Default: 7 days (in seconds)
    static let REFRESH_TOKEN_LIFETIME: Double = 60 * 60 * 24 * 7
    /// How long should the email tokens live for: Default 24 hours (in seconds)
    static let EMAIL_TOKEN_LIFETIME: Double = 60 * 60 * 24
    /// Lifetime of reset password tokens: Default 1 hour (seconds)
    static let RESET_PASSWORD_TOKEN_LIFETIME: Double = 60 * 60
    
    
    let BASE = PathComponent(stringLiteral: "api")
    let AUTH_ROUTE = PathComponent(stringLiteral: "auth")
    let LOGIN = PathComponent(stringLiteral: "login")
    let EMAIL_VERIFICATION = PathComponent(stringLiteral: "email-verification")
    let REST_PASSWORD = PathComponent(stringLiteral: "reset-password")
    let VERIFY = PathComponent(stringLiteral: "verify")
    let RECOVER = PathComponent(stringLiteral: "recover")
    let ACCESS_TOKEN = PathComponent(stringLiteral: "accessToken")
    let REGISTER = PathComponent(stringLiteral: "register")
    let ALL = PathComponent(stringLiteral: "all")
    let CURRENT_USER = PathComponent(stringLiteral: "currentUser")
    let USER = PathComponent(stringLiteral: "user")
    let USER_ID = PathComponent(stringLiteral: ":userID")
    let EDIT_CURRENT_USER = PathComponent(stringLiteral: "editCurrentUser")
    let EDIT_USER = PathComponent(stringLiteral: "editUser")
    let DELETE_USER = PathComponent(stringLiteral: "deleteUser")
    let DELETE_CURRENT_USER = PathComponent(stringLiteral: "deleteCurrentUser")
    let USER_ID_STRING = "userID"
    let CHAT_SESSION_ID_STRING = "chatSessionID"
    let CHAT_MESSAGE_ID_STRING = "chatMessageID"
    
    let CHAT_CONTACTS = PathComponent(stringLiteral: "chatContacts")
    let CHAT_SESSION_ID = PathComponent(stringLiteral: ":chatSessionID")
    let POST_SENDER = PathComponent(stringLiteral: "postSender")
    let POST_MESSAGE = PathComponent(stringLiteral: "postMessage")
    let FETCH_CHAT_SESSION_MESSAGES = PathComponent(stringLiteral: "fetchChatSessionMessages")
    let ADD_KEY_TO_USER_URL = PathComponent(stringLiteral: "addKeyToUser")
    let FETCH_USER_CHAT_SESSION = PathComponent(stringLiteral: "fetchUserChatSession")
    let FETCH_CONTACTS = PathComponent(stringLiteral: "fetchContacts")
    let FETCH_CHAT_SESSION = PathComponent(stringLiteral: "fetchChatSession")
    let DELETE_CHAT_SESSION = PathComponent(stringLiteral: "deleteChatSession")
    let DELETE_CHAT_MESSAGE = PathComponent(stringLiteral: "deleteChatMessage")
    let CHAT_MESSAGE_ID = PathComponent(stringLiteral: ":chatMessageID")
    
}
