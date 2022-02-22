//
//  RealmFunction.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/22/22.
//

import Foundation
import RealmSwift
class RealmFunction
{
    public static let shared = RealmFunction()
    private static var realmSwift = try! Realm()
    func downloadData(movieInfo:MovieInfo)
    {
        print("Downloading")
        let titleItem = TitleItem()
        guard let original_title = movieInfo.original_title ?? movieInfo.original_name ,
              let poster_path = movieInfo.poster_path,
              let vote_average = movieInfo.vote_average,
              let overview = movieInfo.overview,
              let release_date = movieInfo.release_date ?? movieInfo.first_air_date ,
              let vote_count = movieInfo.vote_count,
              let backdrop_path = movieInfo.backdrop_path,
              let title = movieInfo.title ?? movieInfo.name,
              let id = movieInfo.id,
              let popularity = movieInfo.popularity,
              let original_language = movieInfo.original_language
        else
        {
            return
        }
        

        
        titleItem.original_title = original_title
        titleItem.poster_path = poster_path
        titleItem.vote_average = vote_average
        titleItem.overview = overview
        titleItem.release_date = release_date
        titleItem.vote_count = Int64(vote_count)
        titleItem.backdrop_path = backdrop_path
        titleItem.title = title
        titleItem.id = Int64(id)
        titleItem.popularity = popularity
        titleItem.original_language = original_language
        saveData(to: titleItem)
    }
     func saveData(to titleItem:TitleItem)
    {
        do {
            try RealmFunction.realmSwift.write {
                RealmFunction.realmSwift.add(titleItem)
               print("iam here")
               
            }
        }
            catch{
                fatalError("error")
            }
        
    }
}
