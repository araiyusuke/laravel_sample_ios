//
//  MockedData.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/21.
//

import Foundation

extension User {
    /// テスト、Previewで使う。
    static let mockedData: [User] = [
        User(name: "田中", email: "tanaka@gmail.com"),
        User(name: "荒井", email: "arai@gmail.com")
    ]
}

extension Token {
    static let mockedData: [Token] = [
        Token(token: "test")
    ]
}
