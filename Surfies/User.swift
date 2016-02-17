//
//  User.swift
//  Surfies
//
//  Created by Barbara Brina on 7/27/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation

class User {
    
    var idParse: String!
    
    var moods: [Mood]? 
    
    var likedShows: [TVShow]?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(idParse, forKey: "id")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        idParse =  aDecoder.decodeObjectForKey("id") as! String
    }
    
    

}