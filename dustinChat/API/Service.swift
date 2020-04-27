//
//  Service.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/27.
//  Copyright © 2020 Dustin. All rights reserved.
//

import Firebase


//#1 fectch User Data
struct Service {
    
    static func fetchUser(completion: @escaping([User]) -> Void) {
        
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                print(document.data())
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                print("\(user.username)")
                print("\(user.fullname)")
                users.append(user)
                completion(users)
                
                
         
            })
        }
        
        
    }
}
