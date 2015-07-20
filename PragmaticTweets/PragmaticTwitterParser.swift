//
//  PragmaticTwitterParser.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/17.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import Foundation

public class PragmaticTwitterParser: NSObject, TwitterParser {

    public func parseTweets(jsonData: AnyObject?) -> [ParsedTweet]? {
        var parsedTweets = [ParsedTweet]()
        if let jsonArray = jsonData as? [[String : AnyObject]] {
            for tweetDict in jsonArray {
                let parsedTweet = parseTweet(tweetDict)
                parsedTweets.append(parsedTweet!)
            }
        }
        return parsedTweets
    }
    
    public func parseTweet(jsonData: AnyObject?) -> ParsedTweet? {
        var parsedTweet : ParsedTweet!
        if let tweetDict = jsonData as? [String : AnyObject] {
            parsedTweet = ParsedTweet()
            parsedTweet.tweetText = tweetDict["text"] as? String
            parsedTweet.createdAt = tweetDict["created_at"] as? String
            let userDict = tweetDict["user"] as! NSDictionary
            parsedTweet.userName = userDict["name"] as? String
            parsedTweet.screenName = userDict["screen_name"] as? String
            parsedTweet.userAvatarURL = NSURL (string: userDict ["profile_image_url"] as! String!)
            parsedTweet.tweetIdString = tweetDict["id_str"] as? String
            if let entities = tweetDict["entities"] as? NSDictionary {
                if let media = entities["media"] as? NSArray {
                    if let mediaString = media[0]["media_url"] as? String {
                        parsedTweet.mediaURL = NSURL(string: mediaString)
                    }
                }
            }
        }
        return parsedTweet
    }
    
    public func parseUser(jsonData: AnyObject?) -> ParsedUser? {
        var parsedUser : ParsedUser!
        if let userDict = jsonData as? [String : AnyObject] {
            parsedUser = ParsedUser()
            parsedUser.name = userDict["name"] as? String
            parsedUser.screenName = userDict["screen_name"] as? String
            parsedUser.location = userDict["location"] as? String
            parsedUser.userDescription = userDict["description"] as? String
            parsedUser.userAvatarURL = NSURL (string: userDict["profile_image_url"] as! String!)
        }
        return parsedUser
    }
}
