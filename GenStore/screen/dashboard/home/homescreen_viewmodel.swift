//
//  homescreen_viewmodel.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 24/11/25.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    private let repo: ProductRepo
    private let cartrepo: CartRepo
    init(repo: ProductRepo = ProductRepoImpl(apiClient: Apiclient.shared),cartrepo: CartRepo = CartRepoImpl(apiClient: Apiclient.shared)) {
        self.repo = repo
        self.cartrepo = cartrepo
    }
    
    var productResponseModel:ProductResponseModel?
    var cartResponseModel:CartResponseModel?
    @Published var isLoading = false
    @Published var errorMessage: String = "Server Error"
    @Published var showErrorToast: Bool = false
    @Published var showSuccessToast: Bool = false
    @Published var tabInd = 0
    @Published var isOpenDrawer = false
    @Published var isShowRaw = false
    @Published var productCount = 1


    func changeTab(to index: Int) {
        print("🔄 Changing tab to: \(index)")
        withAnimation(.easeInOut(duration: 0.3)) {
            tabInd = index
        }
        Task {
            let type: String = {
                switch tabInd {
                case 0: "all"
                case 1: "men"
                case 2: "women"
                case 3: "kids"
                default: "all"
                }
            }()
             await getProduct(type: type)
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
    func toggleRow() {
        print("🚪 Row  called. Current state: \(isShowRaw)")
        withAnimation {
            isShowRaw.toggle()
        }
        print("✅ Row is now: \(isShowRaw)")
    }
    
    func increaseProductCount(){
   
            productCount = productCount + 1}
  
    func decreaseProductCount(){
        if(productCount>1){
            productCount = productCount - 1}
    }
    func getProduct(type:String)async{
        do{
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = "Server Error"
            }
            let res = try await repo.getProduct(type: type)
            await MainActor.run {
                self.productResponseModel = res
                self.showSuccessToast = true
                self.isLoading = false
            }
            print("res product ", res)
        }catch let e{
            await MainActor.run {
                self.errorMessage = e.localizedDescription.isEmpty ? "Server Error" : e.localizedDescription
                self.showErrorToast = true
                self.isLoading = false
            }
            print("Error:", e)
        }
    }
    
    func addToCart(req:CartRequestModel)async{
        do{
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = "Server Error"
            }
            let res = try await cartrepo.addToCart(req: req)
            await MainActor.run {
                self.cartResponseModel = res
                self.showSuccessToast = true
                self.isLoading = false
            }
            print("res product ", res)
        }catch let e{
            await MainActor.run {
                self.errorMessage = e.localizedDescription.isEmpty ? "Server Error" : e.localizedDescription
                self.showErrorToast = true
                self.isLoading = false
            }
            print("Error:", e)
        }
    }
}
