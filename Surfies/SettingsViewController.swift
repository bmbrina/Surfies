//
//  SettingsViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 7/16/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit
import VBFPopFlatButton
import SDWebImage
import APAvatarImageView
import Parse


class SettingsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var profileView: APAvatarImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var timezone: UILabel!
    
    @IBOutlet weak var menuButton: VBFPopFlatButton!
    
    // MARK: Actions
    
    @IBAction func openMenu(sender: AnyObject) {
        
        let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuView") as!
        MenuViewController
        
        let mainNavContr = self.navigationController as! MainNavigationController
        
        menu.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        menu.delegate = mainNavContr
        
        presentViewController(menu, animated: false, completion: nil)
        
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        
       setUserDefaults()
        
        PFUser.logOut()
        
        let viewController: UIViewController = (storyboard?.instantiateInitialViewController())!
        let window: UIWindow = UIApplication.sharedApplication().keyWindow!
        
        UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            window.rootViewController = viewController
        }, completion: nil)
        
        
        
    }
    
    // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleMenu()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUserInfo()
       
    }
    
    // MARK: User defaults
    
    func setUserDefaults() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(false, forKey: didFinishRecommendationsKey)
        
        userDefaults.setBool(false, forKey: hasShownSelectedEpisodeInstructionsKey)
        
        userDefaults.setBool(false, forKey: hasShownRecommendationsIntstructionsKey)
        
        userDefaults.setBool(false, forKey: hasShownMySeriesInstructionsKey)
        
        userDefaults.setBool(false, forKey: hasShownDescriptionIntrstructionsKey)
        
        userDefaults.setBool(false, forKey: hasShownAiringTodayInstructionsKey)
    }
    
    // MARK: User Information
    
    func currentUserInfo() {
        
        let currentUser: PFUser! = PFUser.currentUser()
        
        profileView.contentMode = UIViewContentMode.Center
        profileView.contentMode = UIViewContentMode.ScaleAspectFill
        profileView.borderWidth = 0
        
        if let profilePic = NSURL(string: currentUser["facebookProfileURL"] as! String) {
            profileView.sd_setImageWithURL(profilePic)
            
        } else {
            profileView.image = UIImage(named: "nopreview")
        }
        


        
        
        name.text = currentUser["facebookName"] as? String
        timezone.text = NSTimeZone.localTimeZone().name

        
        
    }
    
    // MARK: Menu
    
    func styleMenu() {
        
        menuButton.currentButtonType = FlatButtonType.buttonMenuType
        menuButton.currentButtonStyle = FlatButtonStyle.buttonPlainStyle
        menuButton.lineThickness = 2
        menuButton.tintColor = UIColor.whiteColor()
    }
    

}
