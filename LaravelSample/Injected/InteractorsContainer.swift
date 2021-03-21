//
//  InteractorsContainer.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation

extension DIContainer {
    
    struct Interactors {
        
        let authInteractor: AuthInteractor
        let userInteractor: UserInteractor

        
        init(authInteractor: AuthInteractor, userInteractor: UserInteractor) {
            self.authInteractor = authInteractor
            self.userInteractor = userInteractor
        }
        
        static var stub: Self {
            .init(authInteractor: StubAuthInteractor(), userInteractor: StubUserInteractor())
        }
    }
}
