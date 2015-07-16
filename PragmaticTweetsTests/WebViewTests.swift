//
//  WebViewTests.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/02.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import XCTest
import PragmaticTweets

class WebViewTests: XCTestCase, UIWebViewDelegate {
    
    var loadedWebViewExpectation : XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        XCTFail("web view load failed")
        loadedWebViewExpectation!.fulfill()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let webViewContents = webView.stringByEvaluatingJavaScriptFromString( "document.documentElement.textContent") {
            if webViewContents != "" {
                loadedWebViewExpectation!.fulfill()
            }
        }
    }
        
    func testAutomaticWebLoad() {
        if let viewController = UIApplication.sharedApplication().windows[0].rootViewController as? ViewController {
            viewController.twitterWebView.delegate = self
            loadedWebViewExpectation = expectationWithDescription("web view auto-load test")
            waitForExpectationsWithTimeout(10.0, handler: nil)
        } else {
            XCTFail("couldn't get root view controller")
        }
    }
}
