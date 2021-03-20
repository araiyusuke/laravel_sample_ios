//
//  AuthInteractor.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import Combine
import SwiftUI

protocol AuthInteractor {
//    func signInWithEmailAndPassword(credential: Credential) -> AnyPublisher<Token, Error>
    func signInWithEmailAndPassword(auth: Binding<Loadable<Token>>, credential: Credential)
}

var cancellables1: Set<AnyCancellable> = []

struct RealAuthInteractor:AuthInteractor {
    let webRepository: AuthWebRepository
    let keyChainRepository: RealAuthKeychainRepository

    init(webRepository: AuthWebRepository) {
        self.webRepository = webRepository
        self.keyChainRepository = RealAuthKeychainRepository()
    }
    
//    func signInWithEmailAndPassword(credential: Credential) -> AnyPublisher<Token, Error> {
    
    func signInWithEmailAndPassword(auth: Binding<Loadable<Token>>, credential: Credential) {
        
        auth.wrappedValue.setIsLoading()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ -> AnyPublisher<Token, Error> in
                fetchToken(credential: credential)
            }
            .flatMap { [keyChainRepository] token -> AnyPublisher<Token, Error> in
                keyChainRepository.store(token: token)
            }
            .sinkToLoadable {
                auth.wrappedValue = $0
            }
            .store(in: &cancellables1)
    }
    
    func fetchToken(credential: Credential) -> AnyPublisher<Token, Error> {
        return webRepository
            .signInWithEmailAndPassword(credential: credential).eraseToAnyPublisher()
    }
    
    
//    func fetchAndStoreToken(credential: Credential) -> AnyPublisher<Void, Error> {
//        return webRepository
//            .signInWithEmailAndPassword(credential: credential)
//            .flatMap { [keyChainRepository] in
//                keyChainRepository.store(token: $0)
//            }
//            .eraseToAnyPublisher()
//    }
//    func fetchAndStoreToken(credential: Credential) -> AnyPublisher<Void, Error> {
//        return webRepository
//            .signInWithEmailAndPassword(credential: credential)
//            .flatMap { [keyChainRepository] in
//                keyChainRepository.store(token: $0)
//            }
//            .eraseToAnyPublisher()
//    }
}

struct StubAuthInteractor: AuthInteractor {
//    func signInWithEmailAndPassword(credential: Credential) -> AnyPublisher<Void, Error>{
    func signInWithEmailAndPassword(auth: Binding<Loadable<Token>>, credential: Credential) {
//        return Just<Void>.withErrorType(Error.self)
    }
}
