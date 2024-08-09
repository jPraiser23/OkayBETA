//
//  FirebaseManager.swift
//  OkayBeta2.0
//
//  Created by mac on 8/9/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

//FIREBASE INITIALIZATION
class FirebaseManager : NSObject{
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
