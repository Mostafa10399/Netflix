//
//  TitlePreviewViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/18/22.
//

import UIKit
import WebKit
import RealmSwift
class TitlePreviewViewController: UIViewController {
    var previewModel:TitlePreviewViewModel?
    var movieInfo:MovieInfo?

    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var youTubeWebView: WKWebView!
    @IBOutlet weak var downloadButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let x = previewModel
        {
            movieName.text = x.title
            overView.text = x.overViewTitle
            guard let url = URL(string: "https://www.youtube.com/embed/\(x.youTubeVideo.videoId)") else
                        {
                            return
                        }
            self.youTubeWebView.load(URLRequest(url: url))
            navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        }
        
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.layer.backgroundColor = UIColor.red.cgColor
        downloadButton.layer.borderWidth = 1
//        downloadButton.layer.borderColor = UIColor.white.cgColor
        youTubeWebView.isHidden = false
        downloadButton.layer.cornerRadius = 8

    }

    
    @IBAction func DownloadPressed(_ sender: UIButton) {
        let titleItem = TitleItem()
        
        guard let movieInfo = movieInfo else {
            return
        }

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

        
        saveData(titleItem:titleItem)
    }
    func saveData( titleItem :TitleItem)
    {
        do{
            try CollectionTableViewCell.realm.write({
                CollectionTableViewCell.realm.add(titleItem)
            })
        }
        catch
        {
            print(error)
        }
    }
    
}
