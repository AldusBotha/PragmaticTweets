//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/07.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//
import UIKit

class TweetDetailViewController: UIViewController, TwitterAPIRequestDelegate {

    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var tweetIdString : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    override func viewWillAppear(animated: Bool) { super.viewWillAppear(animated)
        reloadTweetDetails()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showUserDetailsSegue") {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = userScreenNameLabel.text
            }
        }
    }
    
    @IBAction func unwindToTweetDetailVC (segue: UIStoryboardSegue?) { }
    
    func reloadTweetDetails() {
        if tweetIdString == nil {
            return
        }
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["id" : tweetIdString!]
        let twitterAPIURL = NSURL (string: "https://api.twitter.com/1.1/statuses/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            let jsonObject : AnyObject?
            do {
                try jsonObject = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(rawValue: 0))
            } catch {
                return
            }
            if let tweetDict = jsonObject as? [String:AnyObject] {
                dispatch_async(dispatch_get_main_queue(), {
                    let userDict = tweetDict["user"] as! NSDictionary
                    self.userRealNameLabel.text = userDict["name"] as? String
                    self.userScreenNameLabel.text = userDict["screen_name"] as? String
                    self.tweetTextLabel.text = tweetDict["text"] as? String
                    let userImageURL = NSURL (string: userDict ["profile_image_url"] as! String!)
                    self.userImageButton.setTitle(nil, forState: .Normal)
                    if userImageURL != nil {
                        if let imageData = NSData(contentsOfURL: userImageURL!) {
                            self.userImageButton.setImage(UIImage(data: imageData), forState: UIControlState.Normal)
                        }
                    }
                    if let entities = tweetDict["entities"] as? NSDictionary {
                        if let media = entities ["media"] as? NSArray {
                            if let mediaString = media[0]["media_url"] as? String {
                                if let mediaURL = NSURL(string: mediaString) {
                                    if let mediaData = NSData (contentsOfURL: mediaURL) {
                                        self.tweetImageView.image = UIImage(data: mediaData)
                                    }
                                }
                            }
                        }
                    }
                })
            }
        } else {
            print("handleTwitterData received no data")
        }
    }
}
