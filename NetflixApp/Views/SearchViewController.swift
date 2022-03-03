//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/16/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
//MARK: - Variables
    let searchViewModell = SearchViewModel()
    var searchController: UISearchController!
    var resultsTableViewController: SearchResultViewController?
    let search = SearchResultViewController()
  

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
        
        searchViewModell.gettingUpComingMovies {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    func didTapOnMovie(_ cell: SearchResultViewController, model: TitlePreviewModel, movieInfo: MovieInfo) {
        searchViewModell.didTapOnMovie(model: model, movieInfo: movieInfo) {
            self.performSegue(withIdentifier: "searchMovieInfo", sender: self)
        }
       
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
        return searchViewModell.tableView(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
        let model = searchViewModell.tableView(cellForRowAt: indexPath)
        cell.configure(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchViewModell.tableView(didSelectRowAt: indexPath) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "searchMovieInfo", sender: self)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Download Taped")
                self.searchViewModell.downloadMovie(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = self.searchViewModell.model
            destination.movieInfo = self.searchViewModell.movieInfo
        }
    }
}
