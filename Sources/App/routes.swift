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

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.group("api") { api in
        // Authentication
        try! api.register(collection: AuthenticationController())
    
    let tokenProtected = app.grouped(Constants.shared.BASE)
        .grouped(UserAuthenticator())
        
        //MARK:- Chat Routes
        let chatController = ChatSessionController()
        tokenProtected.get(Constants.shared.CHAT_CONTACTS, use: chatController.fetchContacts)
        tokenProtected.post(Constants.shared.POST_SENDER, use: chatController.postSession)
        tokenProtected.post(Constants.shared.POST_MESSAGE, Constants.shared.CHAT_SESSION_ID, use: chatController.postMessage)
        tokenProtected.put(Constants.shared.ADD_KEY_TO_USER_URL, Constants.shared.USER_ID, use: chatController.addPublicKeyToUser)
        tokenProtected.get(Constants.shared.FETCH_CONTACTS, use: chatController.fetchContacts)
        tokenProtected.get(Constants.shared.FETCH_CHAT_SESSION, Constants.shared.CHAT_SESSION_ID, use: chatController.fetchChatSession)
        tokenProtected.get(Constants.shared.FETCH_USER_CHAT_SESSION, Constants.shared.USER_ID, use: chatController.fetchUsersChatSessions)
        tokenProtected.delete(Constants.shared.DELETE_CHAT_SESSION, Constants.shared.CHAT_SESSION_ID, use: chatController.deleteChatSession)
        tokenProtected.get(Constants.shared.FETCH_CHAT_SESSION_MESSAGES, Constants.shared.CHAT_SESSION_ID, use: chatController.fetchChatSessionMessages)
        tokenProtected.delete(Constants.shared.DELETE_CHAT_MESSAGE, Constants.shared.CHAT_MESSAGE_ID, use: chatController.deleteChatMessage)
    }
}
