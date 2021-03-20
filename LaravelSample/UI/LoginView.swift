//
//  LoginView.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import SwiftUI
import Combine
import KeychainAccess

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private(set) var auth: Loadable<Token>
    @Environment(\.injected) private var injected: DIContainer


    public let authWebRepository = RealAuthWebRepository(
        session: configuredURLSession(),
        baseURL: "http://localhost:8081/api/")

    init(auth: Loadable<Token> = .notRequested) {
        self._auth = .init(initialValue: auth)
    }
    
    private static func configuredURLSession() -> URLSession {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        // キャッシュを無効
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private var content: AnyView {
        switch auth {
        case .notRequested:
            return AnyView(loginFormView)
        case .isLoading:
            return AnyView(loadingView)
        case let .loaded(token):
            return AnyView(loadedView(token: token))
        case let .failed(error):
            return AnyView(errorView(error))
        }
    }

    var body: some View {
        content
    }
}

private var cancellables: Set<AnyCancellable> = []

private extension LoginView {
    var loginFormView: some View {
        VStack(spacing: 20) {
            TextField("email", text: $email)
            TextField("password", text: $password)
            Button(action: {
                let credential = Credential(password: password, email: email)
                injected.interactors.authInteractor.signInWithEmailAndPassword(auth: $auth, credential: credential)
            }){
                Text("ログイン")
            }
        }
    }
    
    var loadingView: some View {
        Text("ローディング")
    }
    
    func loadedView(token: Token) -> some View {
        return Text(token.token)
    }
    
    func errorView(_ error: Error) -> some View {
        return Text("Error").onAppear() {
            switch error {
            case APIError.unexpectedResponse:
                print("どうあ")
            default:
                print("デフォルおｔ")
            }
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
