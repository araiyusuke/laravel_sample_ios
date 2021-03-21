//
//  ContentView.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import SwiftUI

struct ContentView: View {
    
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }
    
    var body: some View {
        LoginView().inject(container)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(container: .preview)
    }
}
