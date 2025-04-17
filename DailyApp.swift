//
//  DailyApp.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

@main
struct DailyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = AppViewRouter()

    var body: some Scene {
        WindowGroup {
            if router.isLoggedIn {
                ContentView()
                    .environmentObject(router)
            } else {
                LoginView()
                    .environmentObject(router)
            }
        }
    }
}
