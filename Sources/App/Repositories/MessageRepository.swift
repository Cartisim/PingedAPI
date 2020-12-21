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

protocol MessageRepository: Repository {
    func create(_ message: Message) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Message]>
    func find(id: UUID) -> EventLoopFuture<Message?>
    func set<Field>(_ field: KeyPath<Message, Field>, to value: Field.Value,for messageID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == Message
    func count() -> EventLoopFuture<Int>
}

struct DatabaseMessageRepository: MessageRepository, DatabaseRepository {
    var database: Database
    
    func create(_ message: Message) -> EventLoopFuture<Void> {
        return message.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return Message.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[Message]> {
        return Message.query(on: database)
            .filter(\.$id == \._$id)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
    func find(id: UUID) -> EventLoopFuture<Message?> {
        return Message.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func set<Field>(_ field: KeyPath<Message, Field>, to value: Field.Value, for messageID: UUID) -> EventLoopFuture<Void> where Field : QueryableProperty, Field.Model == Message {
        return Message.query(on: database)
            .filter(\.$id == messageID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return Message.query(on: database).count()
    }
    
}


extension Application.Repositories {
    var messages: MessageRepository {
        guard let storage = storage.makeMessageRepository else {
            fatalError("Message Repository no configured, use: app.messageRepository.use()")
        }
        return storage(app)
    }
    func use(_ make: @escaping (Application) -> (MessageRepository)) {
        storage.makeMessageRepository = make
    }
}

