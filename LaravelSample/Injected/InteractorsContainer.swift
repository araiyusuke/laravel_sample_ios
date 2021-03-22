//
//  InteractorsContainer.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation

extension DIContainer {
    
    /// DIで管理するインタラクタ
    struct Interactors {
        
        let auth: AuthInteractor
        let user: UserInteractor

        init(authInteractor: AuthInteractor, userInteractor: UserInteractor) {
            self.auth = authInteractor
            self.user = userInteractor
        }
        
        static var stub: Self {
            .init(authInteractor: StubAuthInteractor(), userInteractor: StubUserInteractor())
        }
    }
}
