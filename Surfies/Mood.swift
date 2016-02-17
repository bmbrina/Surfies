//
//  Mood.swift
//  Surfies
//
//  Created by Barbara Brina on 7/23/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Parse

class Mood: PFObject, PFSubclassing {
    
   @NSManaged var type: String
    
    enum ArrayResponse {
        
        case Success([Mood])
        
        case Failure(NSError)
        
    }
  
    enum MoodEmojiRelation: String {
        
        case Exciting = "🙀"
        
        case Scary = "👻"
        
        case Happy = "😊"
        
        case Romantic = "😍"
        
        case ForYou = "⭐️"
        
        case Dreamy = "💭"
        
        case Inspiring = "🏆"
        
        case Curious = "📜"
        
        case Nostalgic = "🏃"
        
        func moodName() -> String {
            switch self {
            case Exciting:
                return "Exciting"
                
            case Scary:
                return "Scary"
                
            case Happy:
                return "Happy"
                
            case Romantic:
                return "Romantic"
                
            case ForYou:
                return "For You"
                
            case Dreamy:
                return "Dreamy"
                
            case Inspiring:
                return "Inspiring"
                
            case Curious:
                return "Curious"
                
            case Nostalgic:
                return "Nostalgic"
                
            }
        }
        
        private func functionForShow() -> (((response: TVShow.ArrayResponse) -> ()) -> ())? {
            
            switch self {
            case Exciting:
                return  TVShow.getShowsForExciting
            
            case Scary:
                return  TVShow.getShowsForScary
                
            case Happy:
                return  TVShow.getShowsForHappy
            
            case Romantic:
                return  TVShow.getShowsForRomantic
                
            case Dreamy:
                return  TVShow.getShowsForDreamy
                
            case Inspiring:
                return  TVShow.getShowsForInspiring
                
            case Curious:
                return  TVShow.getShowsForCurious
                
            case Nostalgic:
                return  TVShow.getShowsForNostalgic
                
            default:
                return nil
            }
            
            
        }
        
        func shows(tvShowResponse: (TVShow.ArrayResponse) -> ()) {
            self.functionForShow()?({
                response in
                switch response {
                case .Success(let shows):
                    tvShowResponse(TVShow.ArrayResponse.Success(shows))
                    
                case .Failure(let error):
                    tvShowResponse(TVShow.ArrayResponse.Failure(error))
                }
            })

        }
        
    }
    
    static func parseClassName() -> String {
        return "Moods"
    }

}