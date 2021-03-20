//
//  AuthKeychainRepositries.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/20.
//

import Foundation
import Combine
import KeychainAccess

protocol KeyChainRepository {}

protocol AuthKeychainRepository: KeyChainRepository {}

struct RealAuthKeychainRepository: AuthKeychainRepository {
    
    let key = "laravel2"
    let service = "test.com"
    
    func hasStored() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            do {
                let keychain = Keychain(service: service)
                let token = try? keychain.getString(key)
                promise(.success(false))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
//        return token.publisher.map { $0 == nil }.eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<Token, Error> {
        Future<Token, Error> { promise in
            do {
                let keychain = Keychain(service: service)
                let token = try? keychain.getString(key)
                
                if token != nil {
                    promise(.success(Token(token:token!)))
                } 
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func store(token: Token) -> AnyPublisher<Token, Error> {
        return Future<Token, Error> { promise in
            do {
                let keychain = Keychain(service: service)
                keychain[key] = "01234567-89ab-cdef-0123-456789abcdef"
                promise(.success(Token(token: token.token)))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
