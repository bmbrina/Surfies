//
//  Genre.swift
//  Surfies
//
//  Created by Barbara Brina on 7/23/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Parse

class Genre: PFObject, PFSubclassing {
    
    @NSManaged var type: String
    
    @NSManaged var genreId: Int
    
    static func parseClassName() -> String {
        return "Genres"
    }
}