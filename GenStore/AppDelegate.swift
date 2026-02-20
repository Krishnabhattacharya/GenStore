
//  AppDelegate.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 30/12/25.


import UIKit
import GoogleMaps

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("YOUR KEY")
        return true
    }
}
                                
