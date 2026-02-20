//
//  auth_viewmodel.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/12/25.
//
import SwiftUI
class AuthViewModel: ObservableObject {
    @Published var mobileNo = ""
    @Published var password = ""
    @Published var name = ""
    @Published var city = ""
    @Published var landmark = ""
    @Published var address = ""
    @Published var pincode = ""
    
    private let repo: AuthRepo
    init(repo: AuthRepo = AuthRepoImpl(apiClient: Apiclient.shared)) {
        self.repo = repo
    }
    
    var registerResponseModel: RegisterResponseModel?
    var loginresponseModel: LoginResponseModel?
    @Published var isLoading = false
    @Published var errorMessage: String = "Server Error"
    @Published var showErrorToast: Bool = false
    @Published var showSuccessToast: Bool = false
    
    func register() async {
        guard let pincodeInt = Int(pincode), !pincode.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Invalid pincode"
                self.showErrorToast = true
            }
            return
        }
        let req = RegisterRequestModel(
            mobileNumber: mobileNo,
            name: name,
            password: password,
            city: city,
            pincode: pincodeInt,
            address: address,
            nearByLocation: landmark
        )
        do {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = "Server Error"
            }
            
            let response = try await repo.Register(request: req)
            
            await MainActor.run {
                self.registerResponseModel = response
                self.showSuccessToast = true
                self.isLoading = false
            }
            print("res ", response)
            
        } catch let e {
            await MainActor.run {
                self.errorMessage = e.localizedDescription.isEmpty ? "Server Error" : e.localizedDescription
                self.showErrorToast = true
                self.isLoading = false
            }
            print("Error:", e)
        }
    }
    
    
    
    func login()async {
        let req = LoginRequestModel(
            mobileNumber: mobileNo,
            password: password,
            
        )
        do {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = "Server Error"
            }
            let response = try await repo.Login(request: req)
            
            await MainActor.run {
                self.loginresponseModel = response
                StorageServices.shared.setUser(_user:response)
                StorageServices.shared.saveTokens(access: response.tokens?.accessToken ?? "", refresh: response.tokens?.refreshToken ?? "")
                self.showSuccessToast = true
                self.isLoading = false
            }
            print("res ", response)
            
        } catch let e {
            await MainActor.run {
                self.errorMessage = e.localizedDescription.isEmpty ? "Server Error" : e.localizedDescription
                self.showErrorToast = true
                self.isLoading = false
            }
            print("Error:", e)
        }
    }
}
