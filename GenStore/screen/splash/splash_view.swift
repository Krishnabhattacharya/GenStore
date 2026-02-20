//
//  splash_view.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//
import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var splashVM: SplashViewModel
    @EnvironmentObject var router: Router
    @State private var hasNavigated = false

    var body: some View {
        VStack {
            Spacer()
            Text("Gen-Store")
                .font(Font.custom("Caveat", size: 72, relativeTo: .title))
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Color"))
        .onAppear {
            if !hasNavigated {
                hasNavigated = true
                splashVM.setRouter(router)
                splashVM.startNavigation()
            }
        }
    }
}
