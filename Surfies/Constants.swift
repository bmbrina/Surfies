//
//  Constants.swift
//  Surfies
//
//  Created by Barbara Brina on 6/24/15.
//  Copyright (c) 2015 Barbara Brina. All rights reserved.
//

import Foundation


//User Defaults
let didFinishRecommendationsKey = "didFinishRecommendationsKey"
let hasShownMySeriesInstructionsKey = "hasShownMySeriesInstructionsKey"
let hasShownSelectedEpisodeInstructionsKey = "hasShownSelectedEpisodeInstructionsKey"
let hasShownAiringTodayInstructionsKey = "hasShownAiringTodayInstructionsKey"
let hasShownRecommendationsIntstructionsKey = "hasShownRecommendationsIntstructionsKey"
let hasShownDescriptionIntrstructionsKey = "hasShownDescriptionIntrstructionsKey"


//JSON

let gJSONPosterPath = "poster_path"
let gJSONOriginalName = "original_name"
let gJSONGenreID = "genre_ids"
let gJSONResults = "results"
let gJSONSerieID = "id"
let gJSONShowOverview = "overview"
let gJSONShowSeasons = "number_of_seasons"
let gJSONEpisode = "episodes"
let gJSONEpisodeNumber = "episode_number"
let gJSONEpisodeName = "name"
let gJSONEpisodeOverview = "overview"
let gJSONEpisodePicturePath = "still_path"
let gJSONBackdropPath = "backdrop_path"


//API
let ApiKey = "api_key"
let Query = "query"
let WithGenres = "with_genres"

//TvShows TMDB

let TMDb_GetPopular_Url = "https://api.themoviedb.org/3/tv/popular"
let TMDb_ApiKeyValue = "2b12f30ddefca3e200e391da445583c0"
let TMDb_ImageUrl = "https://image.tmdb.org/t/p/w500"
let TMDb_GetShowInfoBy_Url = "https://api.themoviedb.org/3/tv/"
let TMDb_SearchTVShow_Url = "https://api.themoviedb.org/3/search/tv"
let TMDb_DiscoverWithGenres_Url = "https://api.themoviedb.org/3/discover/tv"
let TMDb_AiringToday_Url = "https://api.themoviedb.org/3/tv/airing_today"

//Moods
let Exciting = [12,28] //Adventure & Action
let Scary = [53,9648] // Thriller & Mystery
let Happy = [35] //Comedy
let Romantic = [10749,18] //Romance & Drama
let Dreamy = [14,878] //Fantasy & Science Fiction
let Inspiring = [99] //Documentary
let Curious = [36] //History
let Nostalgic = [10751, 16] // Family & Animation


class Constants {
    
    static func showURLWith(Id: Int) -> String {
        
        
        return "\(TMDb_GetShowInfoBy_Url)\(Id)"
        
    }
    
    static func seasonURLWith(showId: Int, seasonNumber: Int) -> String {
        
        return "\(TMDb_GetShowInfoBy_Url)\(showId)/season/\(seasonNumber)"
    }
    
    static func episodeURLWith(showId: Int, seasonNumber: Int, episodeNumber: Int) -> String {
        
        return "\(TMDb_GetShowInfoBy_Url)\(showId)/season/\(seasonNumber)/episode/\(episodeNumber)"
    }
    
    static func imageURLWith(path: NSURL) -> NSURL {
        
        return NSURL(string: "\(TMDb_ImageUrl)\(path.absoluteString)")!
        
    }
    
    static func stillPathURLWith(path: NSURL) -> NSURL {
        
        return NSURL(string: "\(TMDb_ImageUrl)\(path.absoluteString)")!
    }
    
    static func backdropPathURLWith(path: NSURL) -> NSURL {
        return NSURL(string: "\(TMDb_ImageUrl)\(path.absoluteString)")!
    }
    
}