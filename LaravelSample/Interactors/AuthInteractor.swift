//
//  AuthInteractor.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import Combine
import SwiftUI

protocol BearerTokenInteractor {
    func signInWithEmailAndPassword(auth: Binding<Loadable<Token>>, credential: Credential)
}

var cancellables1: Set<AnyCancellable> = []

struct RealBearerTokenInteractor: BearerTokenInteractor {
    let webRepository: BearerTokenWebRepository
    let keyChainRepository: RealBearerTokenKeychainRepository

    init(webRepository: BearerTokenWebRepository, keyChainRepository: RealBearerTokenKeychainRepository) {
        self.webRepository = webRepository
        self.keyChainRepository = keyChainRepository
    }
        
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
}

struct StubAuthInteractor: BearerTokenInteractor {
    func signInWithEmailAndPassword(auth: Binding<Loadable<Token>>, credential: Credential) {
    }
}
