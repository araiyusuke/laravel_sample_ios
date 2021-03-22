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
    
    @State private var email = "info.keisuke.arai@gmail.com"
    @State private var password = "password"
    @State private(set) var auth: Loadable<Token>
    @State private var toSecondView = true
    @Environment(\.injected) private var injected: DIContainer

    init(auth: Loadable<Token> = .notRequested) {
        self._auth = .init(initialValue: auth)
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
        NavigationView {
            content
        }
    }
}

private extension LoginView {
    var loginFormView: some View {
        VStack(spacing: 10) {
            
            TextField("email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let credential = Credential(password: password, email: email)
                injected.interactors.auth.signInWithEmailAndPassword(loadable: $auth, credential: credential)
            }){
                Text("ログイン")
            }
        }
    }
    
    var loadingView: some View {
        Text("ローディング")
    }
    
    func loadedView(token: Token) -> some View {
        NavigationLink(destination: homeView(token: token), isActive: $toSecondView) {
            EmptyView()
        }
    }
    
    func errorView(_ error: Error) -> some View {
        ErrorView(error:error, retryAction: {
            let credential = Credential(password: password, email: email)
            injected.interactors.auth.signInWithEmailAndPassword(loadable: $auth, credential: credential)
        })
    }
    
    func homeView(token: Token) -> some View {
        HomeView(token: token)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(auth: .notRequested)
    }
}
