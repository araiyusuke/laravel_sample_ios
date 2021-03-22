//
//  Account.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
/// Laravel SanctumからTokenを取得するための認証情報を管理
struct Credential {
    var password:String
    var email:String
    var token:String!
}
