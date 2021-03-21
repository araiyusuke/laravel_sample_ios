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
        
        init(authInteractor: AuthInteractor) {
            self.authInteractor = authInteractor
        }
        
        static var stub: Self {
            .init(authInteractor: StubAuthInteractor())
        }
    }
}
