//
//  homescreen_viewmodel.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 24/11/25.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var tabInd = 0
    @Published var isOpenDrawer = false
    
    func changeTab(to index: Int) {
        print("🔄 Changing tab to: \(index)")
        withAnimation(.easeInOut(duration: 0.3)) {
            tabInd = index
        }
        print("✅ Tab is now: \(tabInd)")
    }
    
    func toggleDrawer() {
        print("🚪 Toggle drawer called. Current state: \(isOpenDrawer)")
        withAnimation {
            isOpenDrawer.toggle()
        }
        print("✅ Drawer is now: \(isOpenDrawer)")
    }
}
