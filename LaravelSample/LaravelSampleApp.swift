//
//  LaravelSampleApp.swift
//  LaravelSample
//
//  Created by 管理者 on 2021/03/17.
//

import SwiftUI

@main
struct LaravelSampleApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(container: AppEnvironment.bootstrap().container)
        }
        .onChange(of: scenePhase) { scene in
            switch scene {
                case .active:
                    print("scenePhase: active")
                case .inactive:
                    print("scenePhase: inactive")
                case .background:
                    print("scenePhase: background")
                @unknown default: break
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
}
