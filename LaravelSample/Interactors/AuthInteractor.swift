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
    func signInWithEmailAndPassword(loadable: LoadableSubject<Token>, credential: Credential)
}

var cancellables1: Set<AnyCancellable> = []

struct RealAuthInteractor: AuthInteractor {
    
    let webRepository: BearerTokenWebRepository
    let keyChainRepository: RealBearerTokenKeychainRepository

    init(webRepository: BearerTokenWebRepository, keyChainRepository: RealBearerTokenKeychainRepository) {
        self.webRepository = webRepository
        self.keyChainRepository = keyChainRepository
    }
        
    func signInWithEmailAndPassword(loadable: LoadableSubject<Token>, credential: Credential) {
        
        loadable.wrappedValue.setIsLoading()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ -> AnyPublisher<Token, Error> in
                fetchToken(credential: credential)
            }
            .flatMap { [keyChainRepository] token -> AnyPublisher<Token, Error> in
                keyChainRepository.store(token: token)
            }
            .sinkToLoadable {
                loadable.wrappedValue = $0
            }
            .store(in: &cancellables1)
    }
    
    func fetchToken(credential: Credential) -> AnyPublisher<Token, Error> {
        return webRepository
            .signInWithEmailAndPassword(credential: credential).eraseToAnyPublisher()
    }
}

struct StubAuthInteractor: AuthInteractor {
    func signInWithEmailAndPassword(loadable: LoadableSubject<Token>, credential: Credential) {
    }
}
