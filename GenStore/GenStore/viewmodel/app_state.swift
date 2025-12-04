//
//  app_state.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 25/11/25.
//
import SwiftUI
class AppState: ObservableObject{
    @Published var homeViewModel = HomeViewModel()
}
//import SwiftUI
//
//class AppState: ObservableObject {
//    @Published var tabInd: Int = 0 {
//        didSet {
//            print("Tab changed to: \(tabInd)")
//        }
//    }
//    
//    @Published var isOpenDrawer: Bool = false {
//        didSet {
//            print("Drawer is now: \(isOpenDrawer)")
//        }
//    }
//    
//    init() {
//        print("AppState initialized")
//    }
//    
//    func changeTab(to index: Int) {
//        print("changeTab called with index: \(index)")
//        withAnimation(.easeInOut(duration: 0.3)) {
//            self.tabInd = index
//        }
//    }
//    
//    func toggleDrawer() {
//        print("toggleDrawer called, current state: \(isOpenDrawer)")
//        withAnimation(.easeInOut(duration: 0.3)) {
//            self.isOpenDrawer.toggle()
//        }
//    }
//}
