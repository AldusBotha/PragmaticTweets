//
//  TwitterParser.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/17.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import Foundation

public protocol TwitterParser {
    
    func parseTweets(jsonData: AnyObject?) -> [ParsedTweet]?
    
    func parseTweet(jsonData: AnyObject?) -> ParsedTweet?
    
    func parseUser(jsonData: AnyObject?) -> ParsedUser?
}
