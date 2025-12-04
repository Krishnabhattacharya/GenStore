//
//  app_navigation_destination.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 19/11/25.
//

import SwiftUI

struct AppNavigationDestination: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginScreen()
                case .register:
                    RegisterScreen()
                case .home:
                    HomeScreen()

//                case .home:
//                    HomeScreen()
//
//                case .product(let id):
//                    ProductDetailsScreen(productId: id)
//
//                case .cart:
//                    CartScreen()
//
//                case .profile:
//                    ProfileScreen()
                }
            }
    }
}

extension View {
    func applyAppNavigation() -> some View {
        self.modifier(AppNavigationDestination())
    }
}
struct RootView: View {
    @StateObject var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginScreen()

                .applyAppNavigation()
        }
        .environmentObject(router)
    }
}
