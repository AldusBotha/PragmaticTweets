//
//  PragmaticTweetsTests.swift
//  PragmaticTweetsTests
//
//  Created by Aldus Botha on 2015/07/17.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import XCTest
import PragmaticTweets

class PragmaticTweetsTests: XCTestCase {
    
    let TWEET_TEXT = "Tweet Text"
    let TWEET_DATE = "2015/01/01"
    let USER_NAME = "UserName"
    let SCREEN_NAME = "Screen Name"
    let LOCATION = "Location"
    let USER_DESCRIPTION = "Description"
    let IMAGE_URL = "https://test.url.com/image.png"
    let TWEET_ID = "1"
    
    var testTweet = [:]
    var testTweetArray = [[:]]
    var testUser = [:]
    
    let twitterParser : TwitterParser = PragmaticTwitterParser()
    
    override func setUp() {
        super.setUp()
        
        testTweet = [
            "text" : TWEET_TEXT,
            "created_at" : TWEET_DATE,
            "user" : [
                "name" : USER_NAME,
                "profile_image_url" : IMAGE_URL
            ],
            "id_str" : TWEET_ID
        ]
        testUser = [
            "name" : USER_NAME,
            "screen_name" : SCREEN_NAME,
            "location" : LOCATION,
            "description" : USER_DESCRIPTION,
            "profile_image_url" : IMAGE_URL
        ]
        testTweetArray = [testTweet, testTweet, testTweet]
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTweetArrayParsing() {
        
        let parsedTweets = twitterParser.parseTweets(testTweetArray)
        
        for tweet in parsedTweets! {
            XCTAssertEqual(tweet.tweetText!, TWEET_TEXT)
            XCTAssertEqual(tweet.createdAt!, TWEET_DATE)
            XCTAssertEqual(tweet.userName!, USER_NAME)
            XCTAssertEqual(tweet.userAvatarURL!, NSURL(string: IMAGE_URL)!)
            XCTAssertEqual(tweet.tweetIdString!, TWEET_ID)
        }
    }
    
    func testSigleTweetParsing() {
        
        let parsedTweet = twitterParser.parseTweet(testTweet)!
        
        XCTAssertEqual(parsedTweet.tweetText!, TWEET_TEXT)
        XCTAssertEqual(parsedTweet.createdAt!, TWEET_DATE)
        XCTAssertEqual(parsedTweet.userName!, USER_NAME)
        XCTAssertEqual(parsedTweet.userAvatarURL!, NSURL(string: IMAGE_URL)!)
        XCTAssertEqual(parsedTweet.tweetIdString!, TWEET_ID)
    }
    
    func testUserParsing() {
        
        let parsedUser = twitterParser.parseUser(testUser)!
        
        XCTAssertEqual(parsedUser.name!, USER_NAME)
        XCTAssertEqual(parsedUser.screenName!, SCREEN_NAME)
        XCTAssertEqual(parsedUser.location!, LOCATION)
        XCTAssertEqual(parsedUser.userDescription!, USER_DESCRIPTION)
        XCTAssertEqual(parsedUser.userAvatarURL!, NSURL(string: IMAGE_URL)!)
    }
    
}
