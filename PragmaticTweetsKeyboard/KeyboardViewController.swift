//
//  KeyboardViewController.swift
//  PragmaticTweetsKeyboard
//
//  Created by Aldus Botha on 2015/07/16.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate, TwitterAPIRequestDelegate {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var tweepNames : [String] = []

    @IBAction func nextKeyboardBarButtonTapped(sender: AnyObject) {
        advanceToNextInputMode()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let twitterParams : Dictionary = ["count":"100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json")
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            do {
                let jsonObject : AnyObject?
                try jsonObject = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(rawValue: 0))
                if let jsonDict = jsonObject as? [String:AnyObject] {
                    if let usersArray = jsonDict ["users"] as? NSArray {
                        self.tweepNames.removeAll(keepCapacity: true)
                        for userObject in usersArray {
                            if let userDict = userObject as? [String:AnyObject] {
                                let tweepName = userDict["screen_name"] as! NSString
                                self.tweepNames.append(tweepName as String)
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Error serializing twitter data")
            }
        } else {
            print ("handleTwitterData received no data")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as UITableViewCell!
        cell.textLabel!.text = "@\(tweepNames[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let keyInputProxy = textDocumentProxy as? UIKeyInput {
            let atName = "@\(tweepNames[indexPath.row])"
            keyInputProxy.insertText(atName)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
