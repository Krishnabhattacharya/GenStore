//
//  drawer.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 24/11/25.
//
import SwiftUI
struct Drawer: View {
//    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    VStack(alignment: .center) {
                        Text("Profile").bold().font(.title)
                        Spacer().frame(height: 20)
                        Image("user")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.2)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .frame(width: geo.size.width * 0.6, alignment: .center)
                    Spacer().frame(height: 20)
                    
                    Text("Profile")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.gray.opacity(0.2))
                    
                    Spacer().frame(height: 20)
                    
                    Text("Address")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.gray.opacity(0.2))
                    
                    Spacer().frame(height: 20)
                    
                    Text("Cart")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.gray.opacity(0.2)).onTapGesture {
                            homeVM.toggleDrawer()
                            router.navigate(to: .cart)
                        }
                    
                    Spacer().frame(height: 20)
                    
                    Text("Order")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.gray.opacity(0.2)).onTapGesture {
                            homeVM.toggleDrawer()
                            router.navigate(to: .order)
                        }
                    
                    Spacer().frame(height: 20)
                    
                    Text("Settings")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.gray.opacity(0.2))
                    
                    Spacer().frame(height: 50)
                    
                    Text("Log out")
                        .font(.title3)
                        .padding()
                        .frame(width: geo.size.width * 0.6, height: 40)
                        .background(Color.red.opacity(0.2))
                        .onTapGesture {
                            withAnimation {
                                homeVM.toggleDrawer()
                                StorageServices.shared.clearUser();
                                router.replace([.login])
                            }
                        }
                }
                .padding()
            }
            .frame(maxWidth: 300, alignment: .leading)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 6)
        }
    }
}
