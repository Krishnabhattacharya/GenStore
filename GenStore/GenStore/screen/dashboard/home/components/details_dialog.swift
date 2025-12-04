//
//  details_dialog.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 21/11/25.
//

import SwiftUI
struct DetailsDialog: View {
    var title: String
    var description: String
    var image: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

           VStack(spacing: 16) {

             HStack {
                    Spacer()
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(6)
                    }
                }

                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: image)) { img in
                        img.resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.title2).bold()

                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(5)
                    }
                }

                Divider()
                HStack{
                    HStack{
                        Text("Color : ").font(.title2)
                        Text("Black").font(.title2).fontWeight(.bold)

                    }
                    Spacer()
                    HStack{
                        Button("-"){
                            
                        }.frame(width: 30,height: 30).clipShape(RoundedRectangle(cornerRadius: 10)).background(.white)
                        Text("1").bold().font(.title3)
                        Button("+"){
                            
                        }.frame(width: 30,height: 30).clipShape(RoundedRectangle(cornerRadius: 10)).background(.white)
                    }.padding(.trailing)
                }.frame(maxWidth:.infinity,alignment:.leading).padding(.leading,20)
                SizeSection()
                HStack {
                    Button(action: onCancel) {
                        Text("Add to cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }

                    Button(action: onConfirm) {
                        Text("WhatsApp")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: 350)
            .shadow(radius: 25)
            .transition(.scale.combined(with: .opacity))
        }
    }
}



struct SizeSection: View{
    var sizeList=["XS","S","M","L","XL"]
    var weightrange=["45-55","60-70","80-90","90-100","100-140"]
    var body:some View{
        VStack{
            HStack{
                Text("Size : ").font(.title2)
                Text("Small").font(.title2).fontWeight(.bold)

            }.frame(maxWidth:.infinity,alignment:.leading).padding(.leading,20).padding(.top,20)
            VStack(alignment: .leading, spacing: 12) {

                HStack(alignment: .top) {

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weight Range")
                            .font(.headline)

                        Text("Size Range")
                            .font(.headline)
                    }
                    .frame(width: 120, alignment: .leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {

                            ForEach(0..<weightrange.count, id: \.self) { index in
                                VStack(spacing: 20) {

                                    Text(weightrange[index])
                                        .font(.caption)
                                    Divider()
                                        .background(Color.gray)
                                    Text(sizeList[index])
                                        .font(.caption)
                                        .bold()
                                }
                                .frame(width: 50)
                            }
                        }
                        .padding(.leading, 5)
                    }
                }
            }.padding().border(Color.black)
            .cornerRadius(10)


        }
    }
}


#Preview {
    HomeScreen()
}
 
