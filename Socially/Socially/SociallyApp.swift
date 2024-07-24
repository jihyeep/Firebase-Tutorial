//
//  SociallyApp.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct SociallyApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authService = AuthService()
    @StateObject var viewModel = PostViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                if authService.user != nil {
                    FeedView()
                        .tabItem {
                            Image(systemName: "text.bubble")
                            Text("Feeds")
                        }
                }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .environmentObject(authService)
            .environmentObject(viewModel)
        }
    }
}
