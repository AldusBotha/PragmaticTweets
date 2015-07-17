//
//  PragmaticTweets_UI_Tests.swift
//  PragmaticTweets UI Tests
//
//  Created by Aldus Botha on 2015/07/16.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import Foundation
import XCTest

class PragmaticTweets_UI_Tests: XCTestCase {
    
    var dateFormatter = NSDateFormatter()
    
    override func setUp() {
        super.setUp()
        dateFormatter.dateFormat = "YYYY/MM/DD hh:mm"
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNavigateToUserDetailView() {
        let app = XCUIApplication()
        sleep(3)
        
        let firstCell = app.tables.cells.elementAtIndex(0)
        let cellTweetUserName = firstCell.staticTexts["cellUserName"].value as! String
        print("Value of cellUserName")
        print(firstCell.staticTexts["cellUserName"].value!)
        firstCell.tap()
        sleep(3)
        
        let tweetDetailUserName = (app.staticTexts["tweetDetailUserName"]).value  as! String
        XCTAssertEqual(cellTweetUserName, tweetDetailUserName)
        (app.buttons["tweetDetailUserButton"]).tap()
        sleep(3)
        
        let userDetailUserName = (app.staticTexts["userDetailUserName"]).value as! String
        XCTAssertEqual(cellTweetUserName, userDetailUserName)
        
        (app.images["userDetailImageView"]).tap()
        sleep(3)
        
        app.buttons["Done"].tap()
        
        app.buttons["Done"].tap()
        
        app.buttons["Tweets"].tap()
    }
    
    func testSendTweet() {
        let app = XCUIApplication()
        app.navigationBars["Tweets"].buttons["Add"].tap()
        app.tables.textViews.elementAtIndex(0).typeText("Test tweet - " + dateFormatter.stringFromDate(NSDate()))
        app.navigationBars["Twitter"].buttons["Post"].tap()
    }
    
    func testSendImageTweet() {
        let app = XCUIApplication()
        app.navigationBars["Tweets"].buttons["Camera"].tap()
        app.tables.textViews.elementAtIndex(0).typeText("Test image tweet - " + dateFormatter.stringFromDate(NSDate()))
        app.navigationBars["Twitter"].buttons["Post"].tap()
    }
    
}
