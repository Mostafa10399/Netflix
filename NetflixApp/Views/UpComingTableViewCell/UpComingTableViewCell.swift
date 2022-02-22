//
//  UpComingTableViewCell.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import UIKit
import SDWebImage
class UpComingTableViewCell: UITableViewCell {
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        playButton.setImage(image, for: .normal)
                          

                       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure (model:MovieInfo)
    {
        DispatchQueue.main.async {
            if let imageUrl = model.poster_path
            {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else
                {
                    return
                }
                self.moviePoster.sd_setImage(with: url, completed: nil)
                self.movieName.text = model.title

            }
        }
    }
    
    
    
    func configure (model:MovieInfoModel)
    {
        DispatchQueue.main.async {
//            if
//            {
                let imageUrl = model.posterURL
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else
                {
                    return
                }
                self.moviePoster.sd_setImage(with: url, completed: nil)
                self.movieName.text = model.title

//            }
        }
    }
    
    
    
}
