//
//  ContentView.swift
//  OkayBeta2.0
//
//  Created by mac on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{

            ScrollView{
                VStack{
                    Picker(selection: $isLoginMode, label:
                            Text("Picker here")){
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    Button{
                        
                    } label:{
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                    }
                    
                    TextField("Email", text : $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text : $password)
                    Button {
                        
                    }label:{
                        HStack{
                            Spacer()
                            Text("Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                }.padding()
  
            }
            .navigationTitle("Create Account")
        }
        
        .padding()
    }
}

#Preview {
    ContentView()
}
