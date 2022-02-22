//
//  YoutubeApi.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/18/22.
//

import Foundation
struct YoutubeApi
{
    let youtubeApiKey = "AIzaSyAAV26jxnfEbiW3-TPVxI3kuFbBxUeGfvU"
    
    func fetchYoutubeVideo(query:String,completion:@escaping (Result<YoutubeDataModel,Error>)->Void)
    {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
        {
            return
        }
        let urlString = "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(youtubeApiKey)"
        print("nagham \(urlString)")
        performRequest(urlString: urlString) { result in
            
            switch result
            {
            
            case .success(let dataModel):
                completion(.success(dataModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    func performRequest(urlString:String,completion:@escaping (Result<YoutubeDataModel,Error>)->Void)
    {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _ , error in
                if error != nil
                {
                    return
                }
                else if let safeData = data {
                    self.decodingData(safeData: safeData) { result in
                        switch result
                        {
                        case .success(let dataModel):
                            completion(.success(dataModel))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                }
                
            }
            task.resume()
            
        }
    }
    func decodingData (safeData:Data,completion:@escaping (Result<YoutubeDataModel,Error>)->Void)
    {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try  decoder.decode(YoutubeDataModel.self, from: safeData)
            completion(.success(decodedData))
        }
        catch
        {
            completion(.failure(error))
            print(error)
        }
    }

}
