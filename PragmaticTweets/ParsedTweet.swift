//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/02.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {

    var tweetText : String?
    var userName : String?
    var createdAt: String?
    var userAvatarURL : NSURL?
    var tweetIdString : String?
    
    init (tweetText: String?, userName: String?, createdAt: String?, userAvatarURL : NSURL?) {
        super.init()
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
    }
    
    override init () {
        super.init()
    }
    
}
