import SwiftUI

struct HomeScreen: View {
    @State private var currentPage: Int = 0
    @State private var showAlert = false
//    @EnvironmentObject var appState:AppState
//    var homeVM: HomeViewModel { appState.homeViewModel }
    @EnvironmentObject var homeVM: HomeViewModel


    var list=["https://images.pexels.com/photos/32437322/pexels-photo-32437322.jpeg","https://images.pexels.com/photos/13024698/pexels-photo-13024698.jpeg","https://images.pexels.com/photos/30404377/pexels-photo-30404377.jpeg",];
    var body: some View {
        ZStack(alignment: .leading,) {
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { index in
                        AsyncImage(url: URL(string: list[currentPage])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
                                .background(Color.black)
                                .clipped()
                        } placeholder: {
ProgressView()
                                   
                        }

                        }
                           
               
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                UpperRow()
                Spacer()
                VStack (alignment: .center){
                    Spacer()
                    
                    HStack {
                        Button(action: previousPage) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 40, height: 40)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        
                        Spacer()
                        
                        Button(action: nextPage) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 40, height: 40)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal)

                    .padding(.horizontal, 10)
                    .padding(.bottom, 180)
                }
                Spacer()
                
                BottomRow().onTapGesture {
showAlert=true
                }
             
             
                Spacer().frame(height: 60)
            }
            if homeVM.isOpenDrawer {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            homeVM.toggleDrawer()
                        }
                    }
                
                HStack {
                    VStack {
                        Spacer().frame(height: 50)
                        Drawer()
                        Spacer().frame(height: 50)
                    }
                    .transition(.move(edge: .leading))
                    
                    Spacer()
                }
            }
            if showAlert {
                DetailsDialog(
                    title: "Are you sure?",
                    description: "Do you really want to perform this action?",
                    image: "https://images.pexels.com/photos/32437322/pexels-photo-32437322.jpeg",
                    onConfirm: {
                        showAlert = false
                    },
                    onCancel: {
                        showAlert = false
                    }
                )
                .animation(.easeInOut, value: showAlert)
            }
    
            
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: currentPage)
    }
    
    func nextPage() {
        if currentPage < 4 { currentPage += 1 }
    }
    
    func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }
}



#Preview {
    HomeScreen().environmentObject(AppState()) 
}
