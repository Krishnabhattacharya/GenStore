//
//  home_screen_components.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 20/11/25.
//
import SwiftUI
struct UpperRow: View {
//    @EnvironmentObject var appState: AppState
//    var homeVM: HomeViewModel { appState.homeViewModel }
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                print("🖼️ User image tapped")
                homeVM.toggleDrawer()
            }) {
                Image("user")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    print("👔 Men tab tapped")
                    homeVM.changeTab(to: 0)
                }) {
                    Text("Men")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 0 ? .blue : .black)
                }
                   
                Button(action: {
                    print("👗 Women tab tapped")
                    homeVM.changeTab(to: 1)
                }) {
                    Text("Women")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 1 ? .blue : .black)
                }
                
                Button(action: {
                    print("👦 Boy tab tapped")
                    homeVM.changeTab(to: 2)
                }) {
                    Text("Boy")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 2 ? .blue : .black)
                }
                
                Button(action: {
                    print("👧 Girl tab tapped")
                    homeVM.changeTab(to: 3)
                }) {
                    Text("Girl")
                        .font(.title3)
                        .foregroundColor(homeVM.tabInd == 3 ? .blue : .black)
                }
            }
         
            Spacer()
        }
        .padding()
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        )
        .padding(.horizontal)
    }
}
struct BottomRow:View{
    var body: some View{
        VStack{
            VStack{
                HStack{
                    ForEach(0..<5,id:\.self){
                        index in VStack{
                            
                        }.frame(width: 20, height: 20)
                            .background(Color.red)
                            .cornerRadius(5)
                    }
                    Spacer()
                }
                HStack {
                    ForEach(0..<5, id: \.self) { index in
                        Text("\(index)")
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }
                    Spacer()
                    Text("Rs : 120/").font(.title3).fontWeight(.bold)
                    Spacer().frame(width: 50)

                }

            }.frame(maxWidth: .infinity, maxHeight: 100).padding(.leading,20).background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
            )
            
            HStack {
                Image("cart_icon")
                    .resizable().padding()
                    .scaledToFill()
                    .frame(width: 60, height: 60).background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                Spacer()
                
                Image("whatsapp_icon")
                    .resizable().padding()
                    .scaledToFill()
                    .frame(width: 60, height: 60).background(.white)                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 100)
            
            .padding(.horizontal)
        }
        
    }
    }

#Preview{
    HomeScreen()
}
