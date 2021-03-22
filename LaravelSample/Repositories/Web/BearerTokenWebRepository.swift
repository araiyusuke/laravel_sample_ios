//
//  LoginWebRepository.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation
import Combine

protocol BearerTokenWebRepository: WebRepository {
    func signInWithEmailAndPassword(auth: Loadable<Token>, credential: Credential)-> AnyPublisher<Token, Error>
    func signInWithEmailAndPassword(credential: Credential)-> AnyPublisher<Token, Error>
}

struct RealBearerTokenWebRepository: BearerTokenWebRepository {
    let session: URLSession
    let baseURL: String
    var body:Data?
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func signInWithEmailAndPassword(auth: Loadable<Token>, credential:Credential) -> AnyPublisher<Token, Error>  {
        return call(endpoint: API.signIn, credential: credential)
    }
    
    func signInWithEmailAndPassword(credential:Credential) -> AnyPublisher<Token, Error>  {
        return call(endpoint: API.signIn, credential: credential)
    }
}

extension RealBearerTokenWebRepository {
    enum API {
        case signIn
    }
}

extension RealBearerTokenWebRepository.API: APICall {
    
    /// Enumの値に合わせてURLのパスを返す
    var path: String {
        switch self {
        case .signIn:
            return "singin"
        }
    }
    
    /// POST or GET
    var method: String {
        switch self {
        case .signIn:
            return "POST"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
