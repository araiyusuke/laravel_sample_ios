//
//  UserRepository.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/21.
//

import Foundation
import Combine

protocol UserWebRepository: WebRepository {
    func load(token: Token) -> AnyPublisher<User, Error>
}

struct RealUserWebRepository: UserWebRepository {
    
    let session: URLSession
    let baseURL: String
    var body:Data?
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func load(token: Token) -> AnyPublisher<User, Error>  {
        return call(endpoint: API.list, token: token)
    }
}

extension RealUserWebRepository {
    enum API {
        case list
    }
}

extension RealUserWebRepository.API: APICall {
    var path: String {
        switch self {
        case .list:
            return "users"
        }
    }
    var method: String {
        switch self {
        case .list:
            return "POST"
        }
    }
    var headers: [String: String]? {
//        return ["Accept": "application/json"]
        let token = Token(token: "17|GkvJ8chkefDfC0N8rF5Nqe4VNBVjP23fNIBeOzqy")
        return ["Authorization": "Bearer \(token.token)"]
    }
    func body() throws -> Data? {
        return nil
    }
}

