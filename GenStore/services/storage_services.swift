//
//  storage_services.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 08/12/25.
//

import SwiftUI

class StorageServices {
    static let shared = StorageServices()
     private init() {}
    func setUser(_user:LoginResponseModel){
        if let data=try? JSONEncoder().encode(_user){
            UserDefaults.standard.set(data,forKey: userModelKey)
        }
    }
    func getUser()->LoginResponseModel?{
        if let data = UserDefaults.standard.data(forKey: userModelKey){
            return try? JSONDecoder().decode(LoginResponseModel.self, from: data)
        }
        return nil
    }
    func clearUser() {
           UserDefaults.standard.removeObject(forKey: userModelKey)
       }
    
    
     func saveTokens(access: String, refresh: String) {
        UserDefaults.standard.set(access, forKey: accessTokenKey)
        UserDefaults.standard.set(refresh, forKey: refreshTokenKey)
    }

     func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
     var accessToken: String? {
        UserDefaults.standard.string(forKey: accessTokenKey)
    }

     var refreshToken: String? {
        UserDefaults.standard.string(forKey: refreshTokenKey)
    }
}
