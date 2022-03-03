
import Foundation
class ComingSoonViewModel
{let apiCaller = ApiCaller()
    let youtube = YoutubeApi()
    var upcomingData = [MovieInfo]()
    var model:TitlePreviewModel?
    var movieInfo:MovieInfo?
  
    func tableView( numberOfRowsInSection section: Int) -> Int {
        return upcomingData.count
    }
    
    func gettingUpComingMovies(completion:@escaping ()->())
    {
        apiCaller.fetchDataForUpComingMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                self.upcomingData = movieDataModel.results
                completion()
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func tableView (cellForRowAt indexPath: IndexPath) -> MovieInfoModel? {
        guard let title = upcomingData[indexPath.row].title ?? upcomingData[indexPath.row].name , let poster = upcomingData[indexPath.row].poster_path else
        {
            return nil
        }
        let model = MovieInfoModel(title: title, posterURL: poster)
        
        return model
    }
    
    func tableView( didSelectRowAt indexPath: IndexPath,completion:@escaping ()->()) {
        guard let title = upcomingData[indexPath.row].title ?? upcomingData[indexPath.row].name,let overView = upcomingData[indexPath.row].overview
                else
                {
                    return
                }
        youtube.fetchYoutubeVideo(query: title + " trailer") { result in
            switch result
            {
            case .success(let youtubeData):
                self.movieInfo = self.upcomingData[indexPath.row]
                self.model = TitlePreviewModel(title: title, youTubeVideo: youtubeData.items[0].id, overViewTitle: overView)
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
