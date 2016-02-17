//
//  TVShow.swift
//  Surfies
//
//  Created by Barbara Brina on 6/24/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation
import Alamofire

class TVShow: CustomStringConvertible {
    
    var parseObjectId : String?
    
    var posterURL: NSURL? {
        
        get {
            if let imagePath = imagePath {
                return Constants.imageURLWith(imagePath)
            } else {
                return nil
            }
        }
        
        set {
            if let stringPath = newValue!.path {
               imagePath = NSURL(string: stringPath)
            }
        }
    }
    
    var episodePicutreURL: NSURL? {
        
        get {
            if let imagePath = imagePath {
                return Constants.stillPathURLWith(imagePath)
            } else {
                return nil
            }
        }
        
        set {
            if let stringPath = newValue!.path {
                imagePath = NSURL(string: stringPath)
            }
        }
    }
    
    var backdropURL: NSURL? {
        
        get {
            if let backdropPath = backdropPath {
                return Constants.backdropPathURLWith(backdropPath)
            } else {
                return nil
            }
        }
        
        set {
            if let stringPath = newValue!.path {
                imagePath = NSURL(string: stringPath)
            }
        }
    }
    
    var description: String = ""
    
    private var imagePath: NSURL?
    
    private var backdropPath: NSURL?
    
    var originalName: String!
    
    var genreIds = [Int]()
    
    var serieId = Int()
    
    var showSeasons = Int()
    
    var episodesBySeason = Int()
    
    var episodeName: String = ""
    
    var episodeDescription: String = ""
    
   enum ArrayResponse {
        
        case Success([TVShow])
        
        case Failure(NSError)
        
    }
    
    enum Response {
        
        case Success(TVShow)
        
        case Failure(NSError)
        
    }
    
    class func getPopular (response: (response: TVShow.ArrayResponse)->()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, TMDb_GetPopular_Url, parameters: [ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var showArray = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            showArray.append(TVShow.tvShowWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(showArray))

                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowInfo (showId: Int, response: (response: TVShow.Response)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, Constants.showURLWith(showId), parameters: [ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        let showInfo = TVShow()

                        let numberOfSeasons: AnyObject
                        numberOfSeasons = json[gJSONShowSeasons]!!
                        showInfo.showSeasons = numberOfSeasons as! Int
                        
                        response(response: Response.Success(showInfo))
                    case .Failure(_, let error):
                        response(response: Response.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getSeasonEpisodes (showId: Int, seasonNumber: Int, response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, Constants.seasonURLWith(showId, seasonNumber: seasonNumber), parameters: [ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var seasonEpisodes = [TVShow]()
                        
                        for jsonShow in json[gJSONEpisode] as! [AnyObject] {
                            seasonEpisodes.append(TVShow.seasonEpisodesWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(seasonEpisodes))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getEpisodeInfo (showId: Int, seasonNumber: Int, episodeNumber: Int, response: (response: TVShow.Response) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, Constants.episodeURLWith(showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber), parameters: [ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        let episodeInfo = TVShow()
                        
                            let episodeName: AnyObject
                            let episodeDesc: AnyObject
                            episodeName = json[gJSONEpisodeName]!!
                            episodeInfo.episodeName = episodeName as! String
                            episodeDesc = json[gJSONEpisodeOverview]!!
                            episodeInfo.episodeDescription = episodeDesc as! String
                            
                            if let imagePath: String = json[gJSONEpisodePicturePath] as? String {
                                episodeInfo.imagePath = NSURL(string: imagePath)
                            }
                        
                        response(response: Response.Success(episodeInfo))
                    case .Failure(_, let error):
                        response(response: Response.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getSearchShowByTitle (showName: String, response: (response: TVShow.ArrayResponse) -> ()) {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, TMDb_SearchTVShow_Url, parameters: [Query: showName, ApiKey : TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var searchResults = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            searchResults.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(searchResults))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    
    class func getShowsForExciting (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Exciting.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var excitingShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            excitingShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(excitingShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForScary (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Scary.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var scaryShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            scaryShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(scaryShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForHappy (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Happy.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var happyShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            happyShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(happyShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForRomantic (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Romantic.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var romanticShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            romanticShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(romanticShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForDreamy (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Dreamy.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var dreamyShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            dreamyShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(dreamyShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForInspiring (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Inspiring.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var inspiringShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            inspiringShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(inspiringShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForCurious (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Curious.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var curiousShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            curiousShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(curiousShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getShowsForNostalgic (response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let genres = Nostalgic.reduce("") {
                acumulated, value in
                let separator = acumulated.characters.count == 0 ? "" : ","
                return acumulated + separator + String(value)
            }
            
            Alamofire.request(.GET, TMDb_DiscoverWithGenres_Url, parameters: [WithGenres : genres, ApiKey: TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var nostalgicShows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            nostalgicShows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(nostalgicShows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
    }
    
    class func getAiringToday(response: (response: TVShow.ArrayResponse) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            Alamofire.request(.GET, TMDb_AiringToday_Url, parameters: [ApiKey : TMDb_ApiKeyValue], encoding: ParameterEncoding.URL, headers: nil)
                .responseJSON(completionHandler: { (_, _, result) -> Void in
                    switch result {
                    case .Success(let json):
                        var shows = [TVShow]()
                        
                        for jsonShow in json[gJSONResults] as! [AnyObject] {
                            shows.append(TVShow.searchResultsWith(jsonShow))
                        }
                        
                        response(response: ArrayResponse.Success(shows))
                    case .Failure(_, let error):
                        response(response: ArrayResponse.Failure(error as NSError))
                    }
                    
                })
        }
        
    }
    
    
    class func seasonEpisodesWith (jsonShow: AnyObject) -> TVShow {
        let season = TVShow()
        
        season.episodesBySeason = jsonShow[gJSONEpisodeNumber] as! Int
        
        return season
    
    }
    
    class func searchResultsWith (jsonShow: AnyObject) -> TVShow {
        let show = TVShow()
        
        if let imagePath: String = jsonShow[gJSONPosterPath] as? String {
            show.imagePath = NSURL(string: imagePath)
        }
        
        if let showName = jsonShow[gJSONOriginalName] as? String {
            show.originalName = showName
        }
        
        
        if let showDescription: String = jsonShow[gJSONEpisodeOverview] as? String {
            show.description = showDescription
        }
        
        if let serieId: Int = jsonShow[gJSONSerieID] as? Int {
            show.serieId = serieId
        }
        
        if let backdropPath: String = jsonShow[gJSONBackdropPath] as? String {
            show.backdropPath = NSURL(string: backdropPath)
        }
        
        return show
    }
    
    class func tvShowWith (jsonShow: AnyObject) -> TVShow {
        
        let show = TVShow()
        
        if let imagePath: String = jsonShow[gJSONPosterPath] as? String {
            show.imagePath = NSURL(string: imagePath)
        }
        
        show.originalName = jsonShow[gJSONOriginalName] as! String
        show.description = jsonShow[gJSONShowOverview] as! String
        show.genreIds = jsonShow[gJSONGenreID] as! [(Int)]
        show.serieId = jsonShow[gJSONSerieID] as! Int
        
     return show
    }

}