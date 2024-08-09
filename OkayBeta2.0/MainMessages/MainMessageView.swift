//
//  MainMessageView.swift
//  OkayBeta2.0
//
//  Created by mac on 7/20/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUser{
    let uid, email, profileImageUrl: String
}
class MainMessageViewModel: ObservableObject{
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    init(){
        fetchCurrentUser()
    }
    private func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        //Fetch Current User
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot,error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user: " , error)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            
           // self.errorMessage = "\(data.description)"
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            
            self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
            
            
        }
    }
}

struct MainMessageView: View {
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessageViewModel()
    var body: some View {
        NavigationView{
            VStack{
//                Text("User: \(vm.chatUser?.uid ?? "") ")
                //CUSTOM NAV BAR
                customNavBar
                messagesView

            }
            .overlay(
                newMessageButton
                ,alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    private var customNavBar: some View {
        HStack{
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width:50, height:50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50)
                    .stroke(Color(.label),lineWidth: 1))
                .shadow(radius: 5)

            //TODO: Change to username
            VStack(alignment:.leading, spacing: 4){
                Text("\(vm.chatUser?.email ?? "")")
                    .font(.system(size: 24, weight: .bold))
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 12)
                    Text("Online")
                        .font(.system(size:12))
                        .foregroundColor(Color(.lightGray))
                }

            }
            Spacer()
            Button{
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size:24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions){
            .init(title: Text("Settings"), message:
            Text("What do you want to do?"), buttons:[
//                        .default(Text("DEFAULT BUTTON"))
                .destructive(Text("Sign Out"), action: {
                    print("Handle Sign Out")
                })
                ,
                    .cancel()
            ])
        }
    }
    

    
    //Messages View
    private var messagesView: some View{
        ScrollView{
            ForEach(0..<10, id: \.self){ num in
                VStack{
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size:32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                        
                        VStack(alignment:.leading){
                            Text("Username")
                                .font(.system(size:16, weight: .bold))

                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size:14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    //New Message View
    private var newMessageButton: some View{
        Button{
            
        } label:{
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
    }
}

#Preview {
    MainMessageView()
//        .preferredColorScheme(.dark)
}
