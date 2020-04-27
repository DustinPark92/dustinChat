//
//  AuthService.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/25.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



struct RegisterationCredentials {
    let email : String
    let password : String
    let userName : String
    let fullName : String
    let profileImage : UIImage
}


struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email : String , password password : String, completion: AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    
    
    func createUser(credentials : RegisterationCredentials , completion : ((Error?) -> Void)?) {
        
        
        //#1 cloud storage - compression
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                    completion!(error)

                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email":credentials.email,"fullname":credentials.fullName
                        ,"profileImageUrl":profileImageUrl
                        ,"uid":uid
                        ,"username":credentials.userName] as [String: Any]
                    // user collection
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                        
                    }
                }
            }
        }
        
    }
    

