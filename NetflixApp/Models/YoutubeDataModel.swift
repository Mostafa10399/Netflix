//
//  YoutubeDataModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/18/22.
//

import Foundation
struct YoutubeDataModel:Codable
{
    let kind:String
    let etag:String
    let nextPageToken:String
    let regionCode:String
    let pageInfo:PageInfo
    let items :[Items]
    
    
}
struct PageInfo:Codable
{
    let totalResults:Int
    let resultsPerPage:Int
}
struct Items:Codable
{
    let kind:String
    let etag:String
    let id:IDVideo
    
}
struct IDVideo:Codable
{
    let kind:String
    let videoId:String
}
