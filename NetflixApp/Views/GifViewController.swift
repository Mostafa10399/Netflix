//
//  GifViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/21/22.
//

import UIKit

class GifViewController: UIViewController {
    @IBOutlet weak var netflixGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netflixGif.image = UIImage.gifImageWithName("netflix-netflix-logo")
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.performSegue(withIdentifier: "home", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    

    

}
