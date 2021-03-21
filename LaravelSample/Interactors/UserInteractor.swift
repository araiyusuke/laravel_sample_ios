//
//  UserInteractor.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/21.
//

import Foundation
import Combine

protocol UserInteractor {
    func load(user: LoadableSubject<User>, token: Token)
}

var cancellables2: Set<AnyCancellable> = []

struct RealUserInteractor: UserInteractor {
    
    let webRepository: UserWebRepository
    
    init(webRepository: UserWebRepository) {
        self.webRepository = webRepository
    }
    
    func load(user: LoadableSubject<User>, token: Token) {
        
        user.wrappedValue.setIsLoading()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [webRepository] _ -> AnyPublisher<User, Error> in
                webRepository.load(token: token).eraseToAnyPublisher()
            }
        
            .sinkToLoadable {
                user.wrappedValue = $0
            }
            .store(in: &cancellables1)
    }
}

struct StubUserInteractor: UserInteractor {
    func load(user: LoadableSubject<User>, token: Token) {
    }
}
