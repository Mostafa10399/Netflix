//
//  MovieDataModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import Foundation
struct MovieDataModel :Codable
{
    let results:[MovieInfo]
}

struct MovieInfo:Codable
{
    let original_title :String?
    let  poster_path :String?
    let video:Bool?
    let vote_average:Float?
    let overview:String?
    let release_date:String?
    let vote_count:Int?
    let adult:Bool?
    let backdrop_path:String?
    let title:String?
    let genre_ids:[Int]?
    let id:Int?
    let original_language:String?
    let popularity:Float?
    let media_type:String?
    let original_name:String?
    let origin_country:[String]?
    let first_air_date:String?
    let name:String?
   
  
}
