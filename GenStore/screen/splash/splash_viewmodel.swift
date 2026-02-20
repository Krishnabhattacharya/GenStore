//
//  splash_viewmodel.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//
import SwiftUI

class SplashViewModel: ObservableObject {
    private var router: Router?
    
    func setRouter(_ router: Router) {
        self.router = router
    }
    
    func startNavigation() {
        let user = StorageServices.shared.getUser()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            DispatchQueue.main.async {
                if let user = user,
                   let id = user.user?.id,
                   !id.isEmpty,
                   let _ = StorageServices.shared.accessToken {
                    self.router?.replace([.home])
                } else {
                    self.router?.replace([.login])
                }
            }
        }
    }
}
