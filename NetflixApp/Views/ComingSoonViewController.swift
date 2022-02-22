//
//  ComingSoonViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import UIKit

class ComingSoonViewController: UIViewController {
    //MARK: - vairables
    let apiCaller = ApiCaller()
    let youtube = YoutubeApi()
    var upcomingData = [MovieInfo]()
    var model:TitlePreviewViewModel?
    var movieInfo:MovieInfo?

    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.tintColor = UIColor.white

        
    }
    
    func gettingUpComingMovies()
    {
        apiCaller.fetchDataForUpComingMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                self.upcomingData = movieDataModel.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension ComingSoonViewController :UITableViewDelegate,UITableViewDataSource
{
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpComingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpComingTableViewCell")
         gettingUpComingMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
        guard let title = upcomingData[indexPath.row].title ?? upcomingData[indexPath.row].name , let poster = upcomingData[indexPath.row].poster_path else
        {
            return UITableViewCell()
        }
        let model = MovieInfoModel(title: title, posterURL: poster)
        
        cell.configure(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(upcomingData[indexPath.row].original_title)\
        tableView.deselectRow(at: indexPath, animated: true)
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
                self.model = TitlePreviewViewModel(title: title, youTubeVideo: youtubeData.items[0].id, overViewTitle: overView)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "upComingToMovieInfo" , sender: self)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Download Taped")
                RealmFunction.shared.downloadData(movieInfo: self.upcomingData[indexPath.row])
            }
            return UIMenu(title: "", image: nil, identifier: nil , options: .displayInline, children: [downloadAction])
        }
        return config
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            
            destination.previewModel = model
            destination.movieInfo = self.movieInfo
        }
    }
    
    
}
