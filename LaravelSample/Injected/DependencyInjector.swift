//
//  DependencyInjector.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/18.
//

import Foundation
import SwiftUI

/// DIContainerにインタラクタを代入して、環境変数(Environment)からアクセスできるようにする。
struct DIContainer: EnvironmentKey {
    let interactors: Interactors
    
    // 必須
    static var defaultValue: Self { Self.default }
    
    // Self.default
    private static let `default` = Self(interactors: .stub)
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer] }
        set { self[DIContainer.self] = newValue }
    }
}

// Preview用
extension DIContainer {
    static var preview: Self {
        .init(interactors: .stub)
    }
}

extension View {
 
    func inject(_ interactors: DIContainer.Interactors) -> some View {
        let container = DIContainer(interactors: interactors)
        return inject(container)// ↓
    }
    
    /// Environment(環境変数)にDIContainer(Interactors)のインスタンスをセットする。
    /// - Parameter container: Viewから呼び出すinteractorsを管理するDIContainer
    /// - Returns: View
    func inject(_ container: DIContainer) -> some View {
        return self.environment(\.injected, container)
    }
}
