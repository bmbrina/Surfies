//
//  UserLikedShows.swift
//  Surfies
//
//  Created by Barbara Brina on 9/3/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Parse

class UserLikedShows: PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    
    @NSManaged var showName: String
    
    @NSManaged var showId: Int
    
    @NSManaged var showPosterUrl: String
    
    @NSManaged var showDescription: String
    
    enum response {
        
        case Success(UserLikedShows)
        
        case Failure(NSError)
        
    }
    
    enum ArrayResponse {
        
        case Success([TVShow])
        
        case Failure(NSError)
        
    }
    
    static func parseClassName() -> String {
        return "UserLikedShows"
    }
    
    static func userLikedShow(show: TVShow, response: (response: UserLikedShows.response) -> Void) {
        
        let tempUser = UserLikedShows()
        
        tempUser.user = PFUser.currentUser()!
        
        if let posterURL = show.posterURL {
            //if let absoluteString = posterURL.absoluteString {
                tempUser.showPosterUrl = posterURL.absoluteString
            //}
        }
        
        tempUser.showName = show.originalName
        tempUser.showDescription = show.description
        tempUser.showId = show.serieId
        
        tempUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if let error = error {
                response(response: self.response.Failure(error))
            } else {
                response(response: self.response.Success(tempUser))
            }
            
        }
    }
    
    static func getLikedShows (response: (ArrayResponse) -> Void) {
        
        var userLikedShows = [TVShow]()
        
        let query = PFQuery(className: "UserLikedShows")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (userShows: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for userShow in userShows! {
                    let tvShow = TVShow()
                    tvShow.posterURL = NSURL(string: userShow["showPosterUrl"] as! String)
                    tvShow.originalName = String(userShow["showName"] as! String)
                    tvShow.description = String(userShow["showDescription"] as! String)
                    tvShow.serieId = userShow["showId"] as! Int
                    tvShow.parseObjectId = userShow.objectId
                    
                    userLikedShows.append(tvShow)
                    
                }
                response(ArrayResponse.Success(userLikedShows))
            } else {
                
                response(ArrayResponse.Failure(error!))
            }
            
        }
    }

}