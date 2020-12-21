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
import FluentPostgresDriver
import Vapor
import JWT
import Mailgun
import QueuesRedisDriver
import NIOSSL
import VaporSecurityHeaders

public func configure(_ app: Application) throws {
    
    switch app.environment {
    case .production:
        
//        let homePath = app.directory.workingDirectory
        
        // MARK: Database
        // Configure PostgreSQL database
        app.http.server.configuration = .init(hostname: "127.0.0.1",
                                              port: 8080,
                                              backlog: 256,
                                              reuseAddress: true,
                                              tcpNoDelay: true,
                                              responseCompression: .disabled,
                                              requestDecompression: .disabled,
                                              supportPipelining: true,
                                              supportVersions: Set<HTTPVersionMajor>([.one]),
                                              tlsConfiguration: .none,
                                              serverName: "PingedAPI",
                                              logger: Logger(label: "api.pinged.io"))
        app.databases.use(
            .postgres(
                hostname: app.config.hostname,
                port: 5432,
                username: app.config.username,
                password: app.config.password,
                database: app.config.database
            ), as: .psql)
        
        // MARK: Middleware
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .OPTIONS, .PUT, .DELETE, .PATCH],
            
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
        
        let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
        app.middleware = .init()
        app.middleware.use(corsMiddleware)
        app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    case .development:
        
//        let homePath = app.directory.workingDirectory
        
        // MARK: Database
        // Configure PostgreSQL database
        app.http.server.configuration = .init(hostname: "127.0.0.1",
                                              port: 8080,
                                              backlog: 256,
                                              reuseAddress: true,
                                              tcpNoDelay: true,
                                              responseCompression: .disabled,
                                              requestDecompression: .disabled,
                                              supportPipelining: true,
                                              supportVersions: Set<HTTPVersionMajor>([.one]),
                                              tlsConfiguration: .none,
                                              serverName: "PingedAPI",
                                              logger: Logger(label: "api.pinged.io"))
        app.databases.use(
            .postgres(
                hostname: app.config.hostname,
                port: 5432,
                username: app.config.username,
                password: app.config.password,
                database: app.config.database
            ), as: .psql)
        
        // MARK: Middleware
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .OPTIONS, .PUT, .DELETE, .PATCH],
            
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
        
        let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
        app.middleware = .init()
        app.middleware.use(corsMiddleware)
        app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    case .testing:
        break
    default:
        break
    }
    
    // MARK: JWT
    if app.environment != .testing {
        let securityHeaders = SecurityHeadersFactory.api()
        app.middleware.use(securityHeaders.build())
        let homePath = app.directory.workingDirectory
        // MARK: Mailgun
        app.mailgun.configuration = .environment
        app.mailgun.defaultDomain = .sandbox
        
        // MARK: App Config
        app.config = .environment
        
        try routes(app)
        try migrations(app)
        try queues(app)
        try services(app)
        try app.queues.startInProcessJobs()
        let jwksFilePath = homePath + app.config.jwksKeypairFile
        guard
            let jwks = FileManager.default.contents(atPath: jwksFilePath),
            let jwksString = String(data: jwks, encoding: .utf8)
        else {
            fatalError("Failed to load JWKS Keypair file at: \(jwksFilePath)")
        }
        try app.jwt.signers.use(jwksJSON: jwksString)
        //        app.logger.logLevel = .trace
        print(app.routes)
    }
}
