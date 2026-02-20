//
//  register_screen.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 19/11/25.
//

import SwiftUI
import ToastSwiftUI
struct RegisterScreen:View{
 
    @EnvironmentObject var router: Router
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View{
        GeometryReader{geo in
            ScrollView{
                VStack{
                    Spacer().frame(height: 10)
                    Image(.register).resizable(capInsets: EdgeInsets()).frame(width: geo.size.width*0.8, height: geo.size.height*0.3)
                    Text("Register").font(.system(size: 30,weight: Font.Weight.bold))
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 30){
                        TextField("Enter Username", text: $authVM.name)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter Mobile No.", text: $authVM.mobileNo)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter Password", text: $authVM.password)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter City", text: $authVM.city)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter PinCode", text: $authVM.pincode)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter Landmark", text: $authVM.landmark)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                        TextField("Enter Address", text: $authVM.address)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding()
                            .border(Color.gray, width: 1).cornerRadius(15)
                    }.padding(.leading,20).padding(.trailing,20)
                    
                    
                    Spacer().frame(height: geo.size.height*0.09)
                    Button {
                        Task { await authVM.register() }
                    } label: {
                        if(authVM.isLoading) {ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            .padding()}else { Text("Register")
                                    .font(.system(size: geo.size.width*0.06, weight: .bold))
                                    .frame(maxWidth: .infinity, minHeight: 60)
                                    .foregroundColor(.white)
                                    .background(Color("Color"))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 10)
                            }}

                    Spacer()
                    Text("Already have an account? Login").onTapGesture {
                        router.replace([.login])
                    }
                }

            }.navigationBarBackButtonHidden(true).toast(isPresenting: $authVM.showErrorToast, message: authVM.errorMessage , icon: .error ,textColor: .red,)
            
            // Success Toast
                .toast(isPresenting: $authVM.showSuccessToast, message: "Registered Successful", icon: .success,textColor: .green,onDisappear: {
                    router.replace([.login])
                })


            }
    }
}
#Preview {
    RegisterScreen()
}

