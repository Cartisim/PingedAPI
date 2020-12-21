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

protocol ChatSessionRepository: Repository {
    func create(_ chat: ChatSession) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[ChatSession]>
    func eagerAll() -> EventLoopFuture<[ChatSession]>
    func find(id: UUID) -> EventLoopFuture<ChatSession?>
    func eagerFind(id: UUID) -> EventLoopFuture<ChatSession?>
    func set<Field>(_ field: KeyPath<ChatSession, Field>,to value: Field.Value, for chatID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == ChatSession
    func count() -> EventLoopFuture<Int>
}


struct DatabaseChatSessionRepository: ChatSessionRepository, DatabaseRepository {
    func create(_ chat: ChatSession) -> EventLoopFuture<Void> {
        return chat.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return ChatSession.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[ChatSession]> {
        return ChatSession.query(on: database)
            .filter(\.$id == \._$id)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
    func eagerAll() -> EventLoopFuture<[ChatSession]> {
        return ChatSession.query(on: database)
            .filter(\.$id == \._$id)
            .sort(\.$createdAt, .descending)
            .with(\.$message)
            .all()
    }
    
    func find(id: UUID) -> EventLoopFuture<ChatSession?> {
        return ChatSession.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func eagerFind(id: UUID) -> EventLoopFuture<ChatSession?> {
        return ChatSession.query(on: database)
            .filter(\.$id == id)
            .with(\.$message)
            .first()
    }
    
    func set<Field>(_ field: KeyPath<ChatSession, Field>, to value: Field.Value, for chatID: UUID) -> EventLoopFuture<Void> where Field : QueryableProperty, Field.Model == ChatSession {
        return ChatSession.query(on: database)
            .filter(\.$id == chatID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return ChatSession.query(on: database).count()
    }
    
    let database: Database
    
    
}


extension Application.Repositories {
    var chatSessions: ChatSessionRepository {
        guard let storage = storage.makeChatSessionRepository else {
            fatalError("Chat Repository no configured, use: app.chatRepository.use()")
        }
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ChatSessionRepository)) {
        storage.makeChatSessionRepository = make
    }
}

