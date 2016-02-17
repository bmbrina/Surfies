//
//  MoodGenre.swift
//  Surfies
//
//  Created by Barbara Brina on 8/27/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Parse

class MoodGenre: PFObject, PFSubclassing {
    
    @NSManaged var mood: String
    
    @NSManaged var genreId: Int
    
    static func parseClassName() -> String {
        return "MoodGenre"
    }
}