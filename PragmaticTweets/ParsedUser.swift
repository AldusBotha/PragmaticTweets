//
//  ParsedUser.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/20.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import Foundation

public class ParsedUser: NSObject {

    public var name : String?
    public var screenName : String?
    public var location : String?
    public var userDescription : String?
    public var userAvatarURL : NSURL?
    
    override init () {
        super.init()
    }
    
}
