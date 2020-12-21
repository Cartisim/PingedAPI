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

struct AppConfig {
    let frontendURL: String
    let apiURL: String
    let noReplyEmail: String
    let hostname: String
    let username: String
    let password: String
    let database: String
    let jwksKeypairFile: String
    let adminName: String
    let adminEmail: String
    let adminPassword: String
    
    static var environment: AppConfig {

        let frontendURL = Environment.get("SITE_FRONTEND_URL") ?? ""
        let apiURL = Environment.get("SITE_API_URL") ?? ""
        let noReplyEmail = Environment.get("NO_REPLY_EMAIL") ?? ""
        let hostname = Environment.get("HOSTNAME") ?? ""
        let username = Environment.get("USERNAME") ?? ""
        let password = Environment.get("PASSWORD") ?? ""
        let database = Environment.get("DATABASE") ?? ""
        let jwksKeypairFile = Environment.get("JWKS_KEYPAIR_FILE") ?? "keypair.jwks"
        let adminName = Environment.get("ADMIN_NAME") ?? ""
        let adminEmail = Environment.get("ADMIN_EMAIL") ?? ""
        let adminPassword = Environment.get("ADMIN_PASSWORD") ?? ""
        
        return .init(frontendURL: frontendURL, apiURL: apiURL, noReplyEmail: noReplyEmail, hostname: hostname, username: username, password: password, database: database, jwksKeypairFile: jwksKeypairFile, adminName: adminName, adminEmail: adminEmail, adminPassword: adminPassword)
    }
}

extension Application {
    struct AppConfigKey: StorageKey {
        typealias Value = AppConfig
    }
    
    var config: AppConfig {
        get {
            storage[AppConfigKey.self] ?? .environment
        }
        set {
            storage[AppConfigKey.self] = newValue
        }
    }
}
