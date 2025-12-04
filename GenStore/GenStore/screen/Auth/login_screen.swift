//
//  login_screen.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 19/11/25.
//
import SwiftUI
struct LoginScreen:View{
    @State private var userName: String = ""
    @State private var passWord: String = ""
    @EnvironmentObject var router: Router

    var body: some View{
        GeometryReader{geo in
            VStack{
                Spacer().frame(height: 10)
                Image(.login).resizable(capInsets: EdgeInsets()).frame(width: geo.size.width*1, height: geo.size.height*0.4)
                Text("LOGIN").font(.system(size: 30,weight: Font.Weight.bold))
                Spacer().frame(height: 20)
                
                VStack(spacing: 30){
                    TextField("Enter Username", text: $userName)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding()
                        .border(Color.gray, width: 1).cornerRadius(15)
                    
                    TextField("Enter Password", text: $passWord)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding()
                        .border(Color.gray, width: 1).cornerRadius(15)
                }.padding(.leading,20).padding(.trailing,20)
                
                
                Spacer().frame(height: geo.size.height*0.09)
                Button(
                    action:{
                        router.replace([.home])
                    },
                    label: {Text("LOGIN")}).font(.system(size: geo.size.width*0.06, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60) .foregroundColor(Color.white)
                    .background(Color("Color"))
                    .cornerRadius(10).padding(.horizontal, 10)
                Spacer()
                Text("Dont have an account? Sign Up").onTapGesture {
                    router.replace([.register])
                }
            }
        }
        }
}
#Preview {
    LoginScreen()
}

