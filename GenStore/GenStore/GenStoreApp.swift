//
//  GenStoreApp.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

import SwiftUI

@main
struct GenStoreApp: App {
    @StateObject var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(homeViewModel)
        }
    }
}
