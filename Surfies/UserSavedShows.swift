//
//  UserSavedShows.swift
//  Surfies
//
//  Created by Barbara Brina on 9/3/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Parse

class UserSavedShows: PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    
    @NSManaged var showName: String
    
    @NSManaged var showId: Int
    
    @NSManaged var showPosterUrl: String
    
    @NSManaged var showDescription: String
    
    enum response {
        
        case Success(UserSavedShows)
        
        case Failure(NSError)
        
    }
    
    enum boolResponse {
        
        case Success(Bool)
        
        case Failure(NSError)
    }
    
    enum ArrayResponse {
        
        case Success([TVShow])
        
        case Failure(NSError)
        
    }
    
    static func parseClassName() -> String {
        return "UserSavedShows"
    }
    
    static func userSavedShow(show: TVShow, response: (response: UserSavedShows.response) -> Void) {
        
        let tempUser = UserSavedShows()
        
        tempUser.user = PFUser.currentUser()!
        
        if let posterURL = show.posterURL {
          //  if let absoluteString = posterURL.absoluteString {
                tempUser.showPosterUrl = posterURL.absoluteString
           // }
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
    
    static func getSavedShows (response: (ArrayResponse) -> Void) {
        
        var userSavedShows = [TVShow]()
        
        let query = PFQuery(className: "UserSavedShows")
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
                    
                    userSavedShows.append(tvShow)
                    
                }
                response(ArrayResponse.Success(userSavedShows))
            } else {
                
                response(ArrayResponse.Failure(error!))
            }
        }
    }
    
    static func isSaved (showId: Int, response: (response: UserSavedShows.boolResponse) -> Void) {
        
        var isSaved: Bool = false
        
        let query = PFQuery(className: "UserSavedShows")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("showId", equalTo: showId)
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            
            if (error != nil) {
                response(response: boolResponse.Failure(error!))
                return
            }
            
            if let results = results {
                if results.count != 0 {
                    isSaved = true
                    
                } else {
                    isSaved = false
                }
                
                response(response: boolResponse.Success(isSaved))
            }
        }
        
    }

}