//
//  UserWatchedEpisodes.swift
//  
//
//  Created by Barbara Brina on 9/7/15.
//
//

import Foundation
import Parse

class UserWatchedEpisodes: PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    
    @NSManaged var showId: Int
    
    @NSManaged var seasonNumber: Int
    
    @NSManaged var episodeNumber: Int
    
    static func parseClassName() -> String {
        return "UserWatchedEpisodes"
    }
    
    enum response {
        case Success(UserWatchedEpisodes)
        
        case Failure(NSError)
    }
    
    enum boolResponse {
        
        case Success(Bool)
        
        case Failure(NSError)
    }
    
    static func userWatchedEpisode(showId: Int, season: Int, episode: Int, response: (response: UserWatchedEpisodes.response) -> Void) {
        
        let tempUser = UserWatchedEpisodes()
        
        tempUser.user = PFUser.currentUser()!
        tempUser.showId = showId
        tempUser.seasonNumber = season
        tempUser.episodeNumber = episode
        
        tempUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if let error = error {
                response(response: self.response.Failure(error))
            } else {
                response(response: self.response.Success(tempUser))
            }
            
        }
    }
    
    static func wasWatched (showId: Int, season: Int, episode: Int, response: (response: UserWatchedEpisodes.boolResponse) -> Void) {
        
        var wasWatched: Bool = false
        
        let query = PFQuery(className: "UserWatchedEpisodes")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("showId", equalTo: showId)
        query.whereKey("seasonNumber", equalTo: season)
        query.whereKey("episodeNumber", equalTo: episode)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                response(response: boolResponse.Failure(error!))
                return
            }
            
            if let results = results {
                if results.count != 0 {
                    wasWatched = true
                } else {
                    wasWatched = false
                }
                
                response(response: boolResponse.Success(wasWatched))
            }
        }
        
    }
    
}