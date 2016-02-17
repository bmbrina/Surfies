//
//  Session.swift
//  Surfies
//
//  Created by Barbara Brina on 7/27/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4

class Session {
    
    var permissions = ["public_profile"]
    
    static let sharedInstance = Session()
    
    enum Response {
        
        case Success(User)
        
        case Failure(NSError)

    }
    
    func loginWithFacebook(response: (response: Session.Response) -> Void) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                response(response: Response.Failure(error))
            } else {
                let newUser = User()
                guard let user = user else {return}
                newUser.idParse = user.objectId
                response(response: Response.Success(newUser))
                self.addFacebookInfoToUser()
            }
                
        }
    }
    
    func addFacebookInfoToUser() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id"])
        graphRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                
                var userData = result as! [String: AnyObject]
                let facebookId = userData["id"] as! String
                let name = userData["name"] as! String
                let pictureURL = String(format: "https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId)
            
                let currentUser: PFUser = PFUser.currentUser()!
                currentUser["facebookId"] = facebookId
                currentUser["facebookName"] = name
                currentUser["facebookProfileURL"] = pictureURL
                currentUser.saveInBackground()
        }
    }


}
