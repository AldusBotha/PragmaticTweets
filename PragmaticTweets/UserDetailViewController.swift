//
//  UserDetailViewController.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/07.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    var screenName : String?
    var userImageURL : NSURL?
    let twitterParser = PragmaticTwitterParser()
    
    @IBAction func unwindToUserDetailVC (segue : UIStoryboardSegue) {
    }
    
    override func viewWillAppear(animated: Bool) { super.viewWillAppear(animated)
        if screenName == nil {
            return
        }
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["screen_name" : screenName!]
        let twitterAPIURL = NSURL (string: "https://api.twitter.com/1.1/users/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserImageDetailSegue" {
            if let imageDetailVC = segue.destinationViewController as? UserImageDetailViewController {
                var urlString = userImageURL!.absoluteString
                urlString = urlString.stringByReplacingOccurrencesOfString ("_normal", withString: "")
                imageDetailVC.userImageURL = NSURL(string: urlString)
            }
        }
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            let jsonObject : AnyObject?
            do {
                try jsonObject = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(rawValue: 0))
            } catch {
                return
            }
            if let parsedUser = twitterParser.parseUser(jsonObject) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.userRealNameLabel.text = parsedUser.name
                    self.userScreenNameLabel.text = parsedUser.screenName
                    self.userLocationLabel.text = parsedUser.location
                    self.userDescriptionLabel.text = parsedUser.userDescription
                    self.userImageURL = parsedUser.userAvatarURL
                    if self.userImageURL != nil {
                        if let userImageData = NSData(contentsOfURL: self.userImageURL!) {
                            self.userImageView.image = UIImage(data: userImageData)
                        }
                    }
                })
            }
        }
    }
}
