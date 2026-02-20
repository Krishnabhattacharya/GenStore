//
//  GenStoreApp.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

import SwiftUI

@main
struct GenStoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var authViewModel=AuthViewModel()
    @StateObject var splashViewModel=SplashViewModel()
    @StateObject var cartViewModel=CartViewModel()
    @StateObject var orderViewModel=OrderViewModel()
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(homeViewModel).environmentObject(authViewModel).environmentObject(splashViewModel).environmentObject(cartViewModel).environmentObject(orderViewModel)
        }
    }
}
