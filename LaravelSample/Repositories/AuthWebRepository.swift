//
//  LoginWebRepository.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import Foundation
import Combine

protocol AuthWebRepository: WebRepository {
//    func loadAuth() -> AnyPublisher<[Country], Error>
//    func signInWithEmailAndPassword(credential: Credential) -> AnyPublisher<Token, Error>
    func signInWithEmailAndPassword(auth: Loadable<Token>, credential: Credential)-> AnyPublisher<Token, Error>
    func signInWithEmailAndPassword(credential: Credential)-> AnyPublisher<Token, Error>

}

struct RealAuthWebRepository: AuthWebRepository {
    let session: URLSession
    let baseURL: String
    var body:Data?
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
//    func signInWithEmailAndPassword(credential:Credential) -> AnyPublisher<Token, Error> {
    func signInWithEmailAndPassword(auth: Loadable<Token>, credential:Credential) -> AnyPublisher<Token, Error>  {
        return call(endpoint: API.signIn, credential: credential)
    }
    
    func signInWithEmailAndPassword(credential:Credential) -> AnyPublisher<Token, Error>  {
        return call(endpoint: API.signIn, credential: credential)
    }
}

extension RealAuthWebRepository {
    enum API {
        case signIn
    }
}

extension RealAuthWebRepository.API: APICall {
    var path: String {
        switch self {
        case .signIn:
            return "singin"
        }
    }
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
