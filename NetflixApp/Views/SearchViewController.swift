//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/16/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
//MARK: - Variables
    var searchController: UISearchController!
    var resultsTableViewController: SearchResultViewController?
    let apiCaller = ApiCaller()
    let youtube = YoutubeApi()
    var model:TitlePreviewViewModel?
    var upcomingData = [MovieInfo]()
    let search = SearchResultViewController()
    var movieInfo:MovieInfo?

    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableViewController = storyboard!.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
        navigationController?.navigationBar.tintColor = UIColor.white

        configurarControladorDeBusca()
        setUpTableView()
        // Do any additional setup after loading the view.
        gettingUpComingMovies()
       
    }
    func gettingUpComingMovies()
    {
        apiCaller.getDiscoverMovies(completion:  { result in
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
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    func configurarControladorDeBusca() {

        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = resultsTableViewController
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController.loadViewIfNeeded()
        searchController.searchBar.delegate = resultsTableViewController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search for a Movie or Tv show"
//        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        resultsTableViewController?.delegate = self
        }

}

extension SearchViewController:SearchResultViewControllerDelegate
{
    
    func didTapOnMovie(_ cell: SearchResultViewController, model: TitlePreviewViewModel, movieInfo: MovieInfo) {
        self.model = model
        self.movieInfo = movieInfo
        
        performSegue(withIdentifier: "searchMovieInfo", sender: self)
    }
    
    
}

extension SearchViewController :UITableViewDelegate,UITableViewDataSource
{
    func setUpTableView()
    {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpComingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpComingTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
        cell.configure(model: upcomingData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = upcomingData[indexPath.row].title ?? upcomingData[indexPath.row].name , let overView = upcomingData[indexPath.row].overview else
        {
            return
        }
        youtube.fetchYoutubeVideo(query: title + " trailer") { result in
            switch result
            {
            case .success(let youTubeDataModel):
                self.model = TitlePreviewViewModel(title: title, youTubeVideo: youTubeDataModel.items[0].id, overViewTitle: overView)
                self.movieInfo = self.upcomingData[indexPath.row]
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "searchMovieInfo", sender: self)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Download Taped")
                RealmFunction.shared.downloadData(movieInfo: self.upcomingData[indexPath.row])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
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
