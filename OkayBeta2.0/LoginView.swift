//
//  ContentView.swift
//  OkayBeta2.0
//
//  Created by mac on 7/9/24.
//

import SwiftUI
import Firebase

class FirebaseManager : NSObject{
    let auth: Auth
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}

struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    
    var body: some View {
        NavigationView{

            ScrollView{
                VStack(spacing: 16){
                    Picker(selection: $isLoginMode, label:
                            Text("Picker here")){
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if isLoginMode == false
                    {
                        Button{
                         //Add Image Button:
                            
                        } label:{
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }

                    
                    Group{
                        TextField("Email", text : $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text : $password)
                    }           
                    .padding(12)
                    .background(Color.white)
                    .foregroundColor(.black)
                    
                    
                    
                    
                    
                    Button {
                        handaleAction()
                    }label:{
                        HStack{
                            Spacer()
                            if(isLoginMode)
                            {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size:14, weight: .semibold))
                            }
                            else{
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size:14, weight: .semibold))
                            }

                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                    
                    
                }.padding()
  
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white:0, alpha : 0.05))
            .ignoresSafeArea())

        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func handaleAction(){
        if isLoginMode
        {
            //Login
            loginUser()
        } else{
            //Create New Account
            createNewAccount()
            
        }
    }
    
    @State var loginStatusMessage = ""
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to login user: " , err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            self.loginStatusMessage = "Successfully logged in user: \(result?.user.uid ?? "")"
        }
    }
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to create user: " , err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
}

#Preview {
    LoginView()
}
