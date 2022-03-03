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
    var previewModel:TitlePreviewModel?
    var movieInfo:MovieInfo?
    let titleViewModel = TitleViewModel()

    
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
        if let movieInfo = movieInfo {
            titleViewModel.DownloadPressed(movieInfo: movieInfo)
        }

        
    }

    
}
