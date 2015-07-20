//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/02.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

public class ParsedTweet: NSObject {

    public var tweetText : String?
    public var userName : String?
    public var screenName : String?
    public var createdAt: String?
    public var userAvatarURL : NSURL?
    public var tweetIdString : String?
    public var mediaURL : NSURL?
    
    init (tweetText: String?, userName: String?, screenName: String?, createdAt: String?, userAvatarURL : NSURL?, mediaURL: NSURL?) {
        self.tweetText = tweetText
        self.userName = userName
        self.screenName = screenName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
        self.mediaURL = mediaURL
    }
    
    override init () {
        super.init()
    }
}
