//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/01.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit
import Social
import Accounts
import Photos
import CoreImage

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate, UISplitViewControllerDelegate {
    
    var parsedTweets : Array<ParsedTweet> = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
        if splitViewController != nil {
            splitViewController!.delegate = self
        }
    }
    
    public func splitViewController(_splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    @IBAction func handleRefresh (sender : AnyObject?) {
        reloadTweets()
        refreshControl!.endRefreshing()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePhotoButtonTapped(sender: UIBarButtonItem) {
        let fetchOptions = PHFetchOptions()
        PHPhotoLibrary.requestAuthorization {
            (authorized: PHAuthorizationStatus) -> Void in
            if authorized == .Authorized {
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
                if let firstPhoto = fetchResult.firstObject as? PHAsset {
                    self.createTweetForAsset(firstPhoto)
                }
            }
        }
    }
    
    func createTweetForAsset(asset: PHAsset) {
        let requestOptions =  PHImageRequestOptions()
        requestOptions.synchronous = true
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(640, 480), contentMode: PHImageContentMode.AspectFit,
                options: requestOptions, resultHandler: {(image:UIImage?, info: [NSObject : AnyObject]?) -> Void in
            var ciImage = CIImage(image: image!)
            ciImage = ciImage!.imageByApplyingFilter("CIPixellate", withInputParameters: ["inputScale" : 15])
            let ciContext = CIContext(options:nil)
            let cgImage = ciContext.createCGImage (ciImage!, fromRect: ciImage!.extent)
            let tweetImage = UIImage (CGImage: cgImage)
            let tweetVC = SLComposeViewController (forServiceType: SLServiceTypeTwitter)
//            let message = NSLocalizedString("Here's a photo I tweeted. #pragsios8", comment:"")
//            tweetVC.setInitialText(message)
            tweetVC.addImage(tweetImage)
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(tweetVC, animated: true, completion: nil)
            })
        })
    }
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController (forServiceType: SLServiceTypeTwitter)
//            let message = NSLocalizedString("I just finished the first project in iOS 8 SDK Development. #pragsios8", comment:"")
//            tweetVC.setInitialText(message)
            presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            print ("Can't send tweet")
        }
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override public func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        if parsedTweet.userAvatarURL != nil {
            cell.avatarImageView.image = nil
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
                if let imageData = NSData (contentsOfURL: parsedTweet.userAvatarURL!) {
                    let avatarImage = UIImage(data: imageData)
                    dispatch_async(dispatch_get_main_queue(), {
                        if cell.userNameLabel.text == parsedTweet.userName {
                            cell.avatarImageView.image = avatarImage
                        } else {
                            print ("oops, wrong cell, never mind")
                        }
                    })
                }
            })
        }
        return cell
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        if self.splitViewController != nil {
            if (self.splitViewController!.viewControllers.count > 1) {
                if let tweetDetailNav = self.splitViewController!.viewControllers[1] as? UINavigationController {
                    if let tweetDetailVC = tweetDetailNav.viewControllers[0] as? TweetDetailViewController {
                        tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
                    }
                }
            } else {
                if let detailVC = storyboard!.instantiateViewControllerWithIdentifier("TweetDetailVC") as? TweetDetailViewController {
                    detailVC.tweetIdString = parsedTweet.tweetIdString
                    splitViewController!.showDetailViewController(detailVC, sender: self)
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func reloadTweets() {
        let twitterParams : Dictionary = ["count":"100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            do {
                let jsonObject : AnyObject?
                try jsonObject = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(rawValue: 0))
                if let jsonArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                    self.parsedTweets.removeAll(keepCapacity: true)
                    for tweetDict in jsonArray {
                        let parsedTweet = ParsedTweet()
                        parsedTweet.tweetText = tweetDict["text"] as? String
                        parsedTweet.createdAt = tweetDict["created_at"] as? String
                        let userDict = tweetDict["user"] as! NSDictionary
                        parsedTweet.userName = userDict["name"] as? String
                        parsedTweet.userAvatarURL = NSURL (string: userDict ["profile_image_url"] as! String!)
                        parsedTweet.tweetIdString = tweetDict["id_str"] as? String
                        self.parsedTweets.append(parsedTweet)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Error serializing twitter data")
            }
        } else {
            print("handleTwitterData received no data")
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController {
                let row = tableView!.indexPathForSelectedRow!.row
                let parsedTweet = parsedTweets [row] as ParsedTweet
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
}

