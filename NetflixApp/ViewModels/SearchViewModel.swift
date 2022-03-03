//
//  SearchViewModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/28/22.
//

import Foundation
class SearchViewModel
{

    var resultsTableViewController: SearchResultViewController?
    let apiCaller = ApiCaller()
    let youtube = YoutubeApi()
    var model:TitlePreviewModel?
    var upcomingData = [MovieInfo]()
    let search = SearchResultViewController()
    var movieInfo:MovieInfo?
    
    func gettingUpComingMovies(completion:@escaping ()->())
    {
        apiCaller.getDiscoverMovies(completion:  { result in
            switch result
            {
            case .success(let movieDataModel):
                self.upcomingData = movieDataModel.results
                completion()
            case .failure(let error):
                print(error)
            }
        }
        )
    }
    func didTapOnMovie(model: TitlePreviewModel, movieInfo: MovieInfo,completion:@escaping()->() ) {
        
        self.model = model
        self.movieInfo = movieInfo
        completion()
        
    }
    func tableView( numberOfRowsInSection section: Int) -> Int {
        return upcomingData.count
    }
    func tableView(cellForRowAt indexPath: IndexPath) -> MovieInfo {

        let model =  upcomingData[indexPath.row]
        return model
    }
    func tableView(didSelectRowAt indexPath: IndexPath,completion:@escaping()->()) {
        guard let title = upcomingData[indexPath.row].title ?? upcomingData[indexPath.row].name , let overView = upcomingData[indexPath.row].overview else
        {
            return
        }
        youtube.fetchYoutubeVideo(query: title + " trailer") { result in
            switch result
            {
            case .success(let youTubeDataModel):
                self.model = TitlePreviewModel(title: title, youTubeVideo: youTubeDataModel.items[0].id, overViewTitle: overView)
                self.movieInfo = self.upcomingData[indexPath.row]
               completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    func downloadMovie(indexPath:IndexPath)
    {
        RealmFunction.shared.downloadData(movieInfo: self.upcomingData[indexPath.row])
    }

    
}
