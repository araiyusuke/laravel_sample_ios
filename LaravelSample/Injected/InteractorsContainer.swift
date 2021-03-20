//
//  InteractorsContainer.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation

extension DIContainer {
    
    struct Interactors {
        
        let bearerTokenInteractor: BearerTokenInteractor
        
        init(bearerTokenInteractor: BearerTokenInteractor) {
            self.bearerTokenInteractor = bearerTokenInteractor
        }
        
        static var stub: Self {
            .init(bearerTokenInteractor: StubAuthInteractor())
        }
    }
}
