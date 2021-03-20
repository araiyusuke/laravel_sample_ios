//
//  DependencyInjector.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    
    let interactors: Interactors
    
    init(interactors: Interactors) {
        self.interactors = interactors
    }
    // 必須
    static var defaultValue: Self { Self.default }
    private static let `default` = Self(interactors: .stub)

}

extension DIContainer {
    static var preview: Self {
        .init(interactors: .stub)
    }
}

extension View {
    
    func inject(_ interactors: DIContainer.Interactors) -> some View {
        let container = DIContainer(interactors: interactors)
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        return self.environment(\.injected, container)
    }
}
extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer] }
        set { self[DIContainer.self] = newValue }
    }
}
