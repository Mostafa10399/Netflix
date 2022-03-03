//
//  ComingSoonViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/15/22.
//

import UIKit

class ComingSoonViewController: UIViewController {
    //MARK: - vairables
    let comingSoonViewModel = ComingSoonViewModel()


    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingData()
        navigationController?.navigationBar.tintColor = UIColor.white

        
    }
    
  func loadingData()
    {
        comingSoonViewModel.gettingUpComingMovies {
            DispatchQueue.main.async {
                self.tableView.reloadData()

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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comingSoonViewModel.tableView(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
         if let model = comingSoonViewModel.tableView(cellForRowAt: indexPath)
        {
             cell.configure(model: model)
             return cell
         }
        
       return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        comingSoonViewModel.tableView(didSelectRowAt: indexPath) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "upComingToMovieInfo" , sender: self)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Download Taped")
                self.comingSoonViewModel.downloadMovie(indexPath: indexPath)
                
            }
            return UIMenu(title: "", image: nil, identifier: nil , options: .displayInline, children: [downloadAction])
        }
        return config
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            
            destination.previewModel = self.comingSoonViewModel.model
            destination.movieInfo = self.comingSoonViewModel.movieInfo
        }
    }
    
    
}
