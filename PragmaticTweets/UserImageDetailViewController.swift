//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/08.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    var userImageURL : NSURL?
    var preGestureTransform : CGAffineTransform?
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        if userImageURL != nil {
            if let imageData = NSData (contentsOfURL: userImageURL!) {
                userImageView.image = UIImage(data:imageData)
            }
        }
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        if sender.state == .Began || sender.state == .Changed {
            let scaledTransform = CGAffineTransformScale(preGestureTransform!, sender.scale, sender.scale)
            userImageView.transform = scaledTransform
        }
    }
    
    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        if sender.state == .Began || sender.state == .Changed {
            let translation = sender.translationInView(self.userImageView)
            let translatedTransform = CGAffineTransformTranslate(preGestureTransform!, translation.x, translation.y)
            userImageView.transform = translatedTransform
        }
    }
}
