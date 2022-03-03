//
//  HomeViewModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/27/22.
//

import Foundation
class HomeViewModel

{
    var movieInfo:MovieInfo?
    var randomMovie:MovieInfo?
    var movieDataModel : MovieDataModel?
    let apiCaller = ApiCaller()
    var model:TitlePreviewModel?
    let youtube = YoutubeApi()
    let sectionTitles :[String] = ["Trending Movies","Trending TV","Popular","Upcoming Movies","Top Rated"]
    func numberOfSections() -> Int {
        return sectionTitles.count
    }
    
     
    func tableView( titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView( heightForHeaderInSection section: Int) -> Float {
        return 40
    }
    func tableView( heightForRowAt indexPath: IndexPath) -> Float {
        return 200
    }
    
     func fetchTrending(completion :@escaping (MovieDataModel)->Void)
    {
        apiCaller.fetchDataForMovies { result in
            
            switch result
            {
            case .success(let movieDataModel):
                self.movieDataModel = movieDataModel
                completion(movieDataModel)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    func fetchTV(completion :@escaping (MovieDataModel)->Void)
    {
        apiCaller.fetchDataForTV { result in
            switch result
            {
            case .success(let movieDataModel):
                self.movieDataModel = movieDataModel
                completion(movieDataModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchTopRated(completion :@escaping (MovieDataModel)->Void)
    {
        apiCaller.fetchDataForTopRatedMovies { result in
        switch result
        {
        case .success(let movieDataModel):
            self.movieDataModel = movieDataModel
            completion(movieDataModel)
        case .failure(let error):
            print(error)
        }
    }
    }
    
    func fetchPopular(completion :@escaping (MovieDataModel)->Void)
    {
        apiCaller.fetchDataForPopularMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                self.movieDataModel = movieDataModel
                completion(movieDataModel)
            case .failure(let error):
                print(error)
            }
    }
    

}
    func fetchUpComing(completion :@escaping (MovieDataModel)->Void)
    {
    apiCaller.fetchDataForUpComingMovies { result in
        switch result
        {
        case .success(let movieDataModel):
            self.movieDataModel = movieDataModel
            completion(movieDataModel)
        case .failure(let error):
            print(error)
        }
    }
    }
    
    func tableView( indexPath: IndexPath) -> MovieDataModel? {
        return movieDataModel
    }
    func configurePoster(completion:@escaping (MovieInfoModel)->Void)
    {
        apiCaller.fetchDataForMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                
                if let movie = movieDataModel.results.randomElement()
                    ,let imageUrl = movie.poster_path , let title = movie.title
                {
                 
                    self.randomMovie = movie
                  
                    let model = MovieInfoModel(title: title, posterURL: imageUrl)
                    completion(model)

                }
            case .failure(let error):
                print(error)
            }
        }
   
    }
    func downloadButtonPressed() {

       guard let randomMovie = randomMovie else {
           return
       }

       RealmFunction.shared.downloadData(movieInfo: randomMovie)
       
   }
    func homeViewTableViewCellDidTabCell( viewModel: TitlePreviewModel, movieInfo: MovieInfo,completion:@escaping ()->()) {
        
        self.movieInfo = movieInfo
        self.model = viewModel
    }
    
    func playButtonPressed(completion:@escaping ()->()) {
        guard let name = randomMovie?.title , let overView = randomMovie?.overview else
        {
            return
        }
        self.movieInfo = randomMovie
        youtube.fetchYoutubeVideo(query: name + " tariler") { result in
            switch result
            {
            case .success(let youtubeDataModel):
                let model = TitlePreviewModel(title: name , youTubeVideo:youtubeDataModel.items[0].id, overViewTitle:overView )
                self.model = model
                completion()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
