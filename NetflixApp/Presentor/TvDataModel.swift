//
//  TvDataModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import Foundation
struct TvDataModel :Codable
{
    let results:[TvInfo]
}

struct TvInfo:Codable
{
    let genre_ids:[Int]
    let original_name:String
    let origin_country:[String]
    let  poster_path :String
    let vote_average:Float
    let vote_count:Int
    let id:Int
    let overview:String
    let backdrop_path:String
    let original_language:String
    let first_air_date:String
    let name:String
    let popularity:Float
    let media_type:String

}
