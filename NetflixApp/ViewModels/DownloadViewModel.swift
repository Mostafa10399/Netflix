//
//  DownloadViewModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 3/1/22.
//
import RealmSwift
import Foundation
class DownloadViewModel
{
    let realm = try! Realm()
    var youtubeApi = YoutubeApi()
    var itemArray:Results<TitleItem>?
    var model:TitlePreviewModel?
    
    func tableView(didSelectRowAt indexPath: IndexPath , completion:@escaping ()->()) {
       
        guard let title = itemArray?[indexPath.row].title ,let overView = itemArray?[indexPath.row].overview else
        {
            return
        }
        youtubeApi.fetchYoutubeVideo(query: title+" trailer") { result in
            switch result
            {
            case .success(let youtubeViewModel):
                self.model = TitlePreviewModel(title: title, youTubeVideo: youtubeViewModel.items[0].id, overViewTitle: overView)
                completion()


            case .failure(let error):
                print(error)

            }
        }
    }
    
    
    func tableView(forRowAt indexPath: IndexPath,completion:@escaping ()->()) {
        do
        {
            guard let item = itemArray?[indexPath.row] else
            {
                return
            }
            try realm.write {
                realm.delete(item)
                completion()
              

            }
        }
        catch
        {
            print(error)
        }

    }
    func tableView( cellForRowAt indexPath: IndexPath,completion:@escaping (MovieInfoModel)->Void)  {
        if let arr = itemArray?[indexPath.row]
        {
            let title = arr.title
            let poster = arr.poster_path
            let model = MovieInfoModel(title: title, posterURL: poster)
            completion(model)

        }
    }
    func loadData(completion:@escaping ()->())
    {
        itemArray = realm.objects(TitleItem.self)
        completion()
        
    }
    
    
    
}
