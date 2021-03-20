//
//  AppEnvironment.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    // シングルトーン
    static func bootstrap() -> AppEnvironment {
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let interactors = configuredInteractors(webRepositories: webRepositories)
        return AppEnvironment(container: .init(interactors: interactors))
    }
    
    private static func configuredInteractors(webRepositories: DIContainer.WebRepositories) -> DIContainer.Interactors {
        let authInteractor = RealAuthInteractor(webRepository: webRepositories.authWebRepository)
        return .init(authInteractor: authInteractor)
    }
    
    // 通信処理の設定
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let authWebRepository = RealAuthWebRepository(session: session, baseURL: "http://localhost:8081/api/")
        return .init(authWebRepository: authWebRepository)
    }
    
}

extension DIContainer {
    struct WebRepositories {
        let authWebRepository: AuthWebRepository
    }
}
