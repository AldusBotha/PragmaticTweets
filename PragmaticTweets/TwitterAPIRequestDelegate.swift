//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/07.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!)
}