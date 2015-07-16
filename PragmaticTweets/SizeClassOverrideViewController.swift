//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Aldus Botha on 2015/07/07.
//  Copyright © 2015 Aldus Botha. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {

    var embeddedSplitVC : UISplitViewController?
    var screenNameForOpenURL : String?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            embeddedSplitVC = segue.destinationViewController as? UISplitViewController
        } else if segue.identifier == "ShowUserFromURLSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = self.screenNameForOpenURL
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > 480.0 {
            let overrideTraits = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
            setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
        } else {
            setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
        }
    }
    
    @IBAction func unwindToSizeClassOverridingVC (segue: UIStoryboardSegue) {
        
    }
}
