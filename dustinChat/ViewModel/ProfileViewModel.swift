//
//  ProfileViewModel.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/29.
//  Copyright © 2020 Dustin. All rights reserved.
//

import Foundation

enum profileViewModel : Int, CaseIterable {
    
    case accountInfo
    case settings
    //=> 옵션 3개까지 늘릴 수 있다.
    //case savedMessages
    
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        //case .savedMessages: return "Saved Messages"
        }
    }
        
    var iconImageName: String {
         
        switch self {
               case .accountInfo: return "person.circle"
               case .settings: return "gear"
        //case .savedMessages: return "envelope"
               }
        }
}

