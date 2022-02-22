//
//  TitleItem.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/20/22.
//

import Foundation
import RealmSwift
class TitleItem:Object
{
    @objc dynamic var original_title :String = ""
    @objc dynamic var poster_path :String = ""
//    @objc dynamic var video:Bool = false
    @objc dynamic var vote_average:Float = 0
    @objc dynamic var overview:String = ""
    @objc dynamic var release_date:String = ""
    @objc dynamic var vote_count:Int64 = 0
    @objc dynamic var backdrop_path:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var id:Int64 = 0
    @objc dynamic var popularity:Float = 0
//    @objc dynamic var media_type:String = ""
    @objc dynamic var original_language:String = ""

//    @objc dynamic var name:String = ""
}



