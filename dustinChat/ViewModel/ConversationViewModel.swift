//
//  ConversationViewModel.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/29.
//  Copyright © 2020 Dustin. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestmap: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "hh:mm a"
        return dateFormmater.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
