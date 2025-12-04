//
//  router.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 19/11/25.
//
import SwiftUI
enum Route:Hashable{
    case login
    case register
    case home
}

class Router : ObservableObject{
    @Published var path = NavigationPath();
    func navigate(to :Route){
        path.append(to)
    }
    func pop() {
           path.removeLast()
       }
       
       func popToRoot() {
           path = NavigationPath()
       }
    func replace(_ routes: [Route]) {
            path = NavigationPath(routes)
        }
}
