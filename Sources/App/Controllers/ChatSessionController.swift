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

struct ChatSessionController {
    
    //  here we fetch all chat sessions, we actually only need to fetch all users and filter them out to see if they have a public key creaeted.
    func fetchContacts(_ req: Request) throws -> EventLoopFuture<[User.ContactOutput]> {
        return req.users
            .allContacts()
            .map{ $0.map { User.ContactOutput(from: $0) } }
    }
    
    //We create a chat session and add the 2 users to it so they can find the chat room in their chat history
    func postSession(_ req: Request) throws -> EventLoopFuture<ChatSession.Output> {
        try ChatSession.Input.validate(content: req)
        let chat = try req.content.decode(ChatSession.Input.self)
        let model = try ChatSession(from: chat)
        let payload = try req.auth.require(Payload.self)
        return req.chatSessions
            .create(model)
            .flatMapThrowing { (_) -> EventLoopFuture<Void> in
                guard let id = model.id else { throw Abort(.notFound) }
                let user = User.find(payload.userID, on: req.db)
                    .unwrap(or: Abort(.notFound))
                let chat = ChatSession.find(id, on: req.db)
                    .unwrap(or: Abort(.notFound))
                return user.and(chat)
                    .flatMap { (user, chat) in
                        user.$chatSession.attach(chat, on: req.db)
                    }
            }
            .flatMapThrowing { (_) -> EventLoopFuture<Void> in
                guard let id = model.id else { throw Abort(.notFound) }
                let contactID = UUID(uuidString: model.contactID)
                let user = User.find(contactID, on: req.db)
                    .unwrap(or: Abort(.notFound))
                let chat = ChatSession.find(id, on: req.db)
                    .unwrap(or: Abort(.notFound))
                return user.and(chat)
                    .flatMap { (user, chat) in
                        user.$chatSession.attach(chat, on: req.db)
                    }
            }
            .map { res in
                return ChatSession.Output(id: model.id?.uuidString ?? "", contactID: model.contactID, fullName: model.fullName, publicKey: model.publicKey)
            }
    }
    
    //We Fetch a chat Session with eager loaded messsages
    func fetchChatSession(_ req: Request) throws -> EventLoopFuture<ChatSession.EagerOutput> {
        guard let id = req.parameters.get(Constants.shared.CHAT_SESSION_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.chatSessions
            .eagerFind(id: id)
            .unwrap(or: Abort(.notFound))
            .map { ChatSession.EagerOutput(from: $0 )}
    }
    
    //We fetch a User with minimal information and anyu Chat Session it has, which are not eager loaded
    func fetchUsersChatSessions(_ req: Request) throws -> EventLoopFuture<User.ChatSessionOutput> {
        guard let id = req.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.users
            .findChatSession(id: id)
            .unwrap(or: Abort(.notFound))
            .map { User.ChatSessionOutput(from: $0) }
    }
    
    //We save a message to out Chat Session
    func postMessage(_ req: Request) throws -> EventLoopFuture<Message.Output> {
        try Message.Input.validate(content: req)
        let message = try req.content.decode(Message.Input.self)
        let model = try Message(from: message)
        return req.messages
            .create(model)
            .map { Message.Output(from: model) }
    }
    
    //We fetch messages via chat session id
    func fetchChatSessionMessages(_ req: Request) throws -> EventLoopFuture<[Message.Output]> {
        guard let id = req.parameters.get(Constants.shared.CHAT_SESSION_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        return req.chatSessions
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .flatMap { session in
                return session.$message.query(on: req.db)
                    .all()
                    .map{ $0.map {Message.Output(from: $0)} }
            }
    }
    
    //Add key to out user
    func addPublicKeyToUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        let key = try req.content.decode(E2EPublicKey.self)
        return req.users
            .set(\.$publicKey, to: key.publicKey, for: id)
            .transform(to: .ok)
    }
    
    func deleteChatSession(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.CHAT_SESSION_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        return req.chatSessions
            .delete(id: id)
            .transform(to: HTTPStatus.ok)
    }
    
    func deleteChatMessage(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.CHAT_MESSAGE_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        return req.messages
            .delete(id: id)
            .transform(to: HTTPStatus.ok)
    }
}

