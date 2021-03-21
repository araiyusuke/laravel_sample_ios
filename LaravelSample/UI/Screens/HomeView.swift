//
//  HomeView.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/21.
//

import SwiftUI


struct HomeView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var user: Loadable<User>
    
    let token:Token
    
   
    init(token: Token, user: Loadable<User> = .notRequested) {
        self._user = .init(initialValue: user)
        self.token = token
    }
    
    private var content: AnyView {
        switch user {
        case .notRequested:
            return AnyView(notRequestedView)
        case .isLoading:
            return AnyView(loadingView)
        case let .loaded(user):
            return AnyView(loadedView(user:user))
        case let .failed(error):
            return AnyView(loadingView)
        }
    }
    
    var body: some View {
        content
    }
    
    var notRequestedView: some View {
        Text("notRequestedView").onAppear() {
            injected.interactors.userInteractor.load(user: $user, token: self.token)
        }
    }
    
    var loadingView: some View {
        Text("ローディング")
    }
    
    func loadedView(user: User) -> some View {
        VStack {
            Text(user.name)
            Text(user.email)
        }
    }
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
////        HomeView()
//    }
//}
