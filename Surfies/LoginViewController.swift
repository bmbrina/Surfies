//
//  LoginViewController.swift
//  Surfies
//
//  Created by Barbara Brina on 6/18/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
   // MARK: Variables
    var permissions = ["public_profile"]
    var signInActive = true
   
    
    // MARK: Outlets
    @IBOutlet weak var FbLogin: UIButton!
    
   // MARK: Actions
    @IBAction func FbLoginButton(sender: AnyObject) {
        
        Session.sharedInstance.loginWithFacebook { (response) -> Void in
            switch response {
            case .Failure(let error):
                print(error, terminator: "")
                
            case .Success(_):
                let viewController: UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigationController")
                let window: UIWindow = UIApplication.sharedApplication().keyWindow!
                
                window.rootViewController = viewController
                
            }
        }
        
    }
    
     // MARK: iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Login button design
        FbLogin.backgroundColor = UIColor.clearColor()
        FbLogin.layer.cornerRadius = 25
        FbLogin.layer.borderWidth = 1
        FbLogin.layer.borderColor = UIColor.whiteColor().CGColor
        
    }

}

