//
//  SearchResultViewModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 3/1/22.
//

import Foundation
class SearchResultViewModel
{
    var movieInfo:MovieInfo?
    var delegate:SearchResultViewControllerDelegate?
    let apiCaller = ApiCaller()
    var model:TitlePreviewModel?
    let youtube = YoutubeApi()
    var movieData :[MovieInfo] = [MovieInfo]()
    
    func collectionView(cellForItemAt indexPath: IndexPath , completion:@escaping (MovieInfoModel?)->Void) {
        if var title = movieData[indexPath.row].title ?? movieData[indexPath.row].name
                , var poster = movieData[indexPath.row].poster_path
        {
            let model = MovieInfoModel(title: title , posterURL: poster)
            completion(model)

        }
        completion(nil)
    }
    
    func downloadMovie(indexPath:IndexPath)
    {
        RealmFunction.shared.downloadData(movieInfo: self.movieData[indexPath.row])
    }

    func collectionView( numberOfItemsInSection section: Int) -> Int {
        return  movieData.count
    }
    func updateSearchResults(query : String,completion:@escaping ()->() ) {
        
        if !query.trimmingCharacters(in: .whitespaces).isEmpty ,query.trimmingCharacters(in: .whitespaces).count >= 1
        {
            
            apiCaller.serach(with: query) { result in
                DispatchQueue.main.async {

                    switch result
                    {
                    case .success(let movieData):
                        self.movieData = movieData.results
                        completion()
                    case .failure(let error):
                        print(error)

                    }
                }
            }
        }
  
        
        
    }
    
    func collectionView( didSelectItemAt indexPath: IndexPath ,completion:@escaping ()->()) {
        if let title = movieData[indexPath.row].original_title ?? movieData[indexPath.row].original_name, let overView = movieData[indexPath.row].overview
        {
            print(title)
            youtube.fetchYoutubeVideo(query: title+" trailer") { result in
                switch result
                {
                case .success(let movieData):
                    self.model = TitlePreviewModel(title: title, youTubeVideo: movieData.items[0].id, overViewTitle: overView)
                    self.movieInfo = self.movieData[indexPath.row]
               
                  
                    print(title+" trailer")
                    completion()
                    print(movieData.items[0].id.videoId)
                case .failure(let error):
                    print(error)
                }
                
            }
            

        }
    }
    
    
}

















//extension SearchResultViewController:UISearchResultsUpdating
//{
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchbar = searchController.searchBar
//        guard let query = searchbar.text  ,
//        !query.trimmingCharacters(in: .whitespaces).isEmpty
//        ,query.trimmingCharacters(in: .whitespaces).count >= 1
//        else
//        {
//            return
//        }
//        apiCaller.serach(with: query) { result in
//            DispatchQueue.main.async {
//
//                switch result
//                {
//                case .success(let movieData):
//                    self.movieData = movieData.results
//                    self.collection.reloadData()
//                case .failure(let error):
//                    print(error)
//
//                }
//            }
//        }
//    }
//}
