//
//  MessageViewModel.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/28.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

struct MessageViewModel {
    private let message : Message
    
    var messageBackGroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive : Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive : Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl)

    }
    
    
    init(message : Message) {
        self.message = message
    }
}
