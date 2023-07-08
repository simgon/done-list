//
//  DoneListApp.swift
//  DoneList
//
//  Created by  on 2023/07/06.
//

import SwiftUI

@main
struct DoneListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 起動時に1回だけやる処理をここに記述する
        
        
        return true
    }
}
