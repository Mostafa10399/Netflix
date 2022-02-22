//
//  ApiCaller.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import Foundation
//protocol ApiCallerDelegate:AnyObject
//{
//    func viewError (error:Error)
//    func movieDataResult(_ apiCaller:ApiCaller,movies:MovieDataModel)
//}

struct ApiCaller
{
//    var delegate:ApiCallerDelegate?
    let apiKey = "893864d0247f4b067086f4ea1c0b5289"
    //MARK: - TV Trending
    func fetchDataForTV(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/trending/tv/day?api_key=\(apiKey)"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }

    //MARK: - TopRated
    func fetchDataForTopRatedMovies(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }
    //MARK: - UpComing Movies
    func fetchDataForUpComingMovies(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }
    
    //MARK: - popular Movies
    func fetchDataForPopularMovies(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }

   //MARK: - Movies Trending
    func fetchDataForMovies(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }
    //MARK: - perform Request
    func performRequest(urlString:String,completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil
                {
//                    delegate?.viewError(error: error!)
                    print("task error\(error!.localizedDescription)")
                    return
                    
                }
                else
                {
                    if let data = data
                    {
                        self.MovieDataEncoding(data) { result in
                            completion(result)
                        }
                  
                    }
                    
                }
            }
            task.resume()
        }
    }
    func MovieDataEncoding(_ safeData:Data,completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let decoder = JSONDecoder()
        
        do {
        let decodedData = try decoder.decode(MovieDataModel.self, from: safeData)
            completion(.success(decodedData))
        }
        catch
        {
//            delegate?.viewError(error: error)
            print("mostafa \(error)")
            completion(.failure(ApiError.FailedToGetData))
        }
        
    }
    enum ApiError:Error
    {
        case FailedToGetData
    }
    
    func getDiscoverMovies(completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }
    func serach(with query:String,completion:@escaping (Result<MovieDataModel,Error>)->Void)
    {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
        {
            return
        }
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)"
        performRequest(urlString: urlString) { result in
            completion(result)
        }
    }
}
