//
//  DataCollectionViewCell.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/12/22.
//

import UIKit
import SDWebImage
class DataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure (model :MovieInfoModel)
    {
//        if let imageUrl = model.posterURL
//        {
            DispatchQueue.main.async {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else
                {
                    return
                }
            
                self.image.sd_setImage(with: url, completed: nil)
                
            }
           
//        }
    }
        func configure (model :MovieInfo)
        {
            if let imageUrl = model.poster_path
                    {

                DispatchQueue.main.async {
                    guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else
                    {
                        return
                    }
                
                    self.image.sd_setImage(with: url, completed: nil)
                    
                }
            }
               
 
    }
    

}
