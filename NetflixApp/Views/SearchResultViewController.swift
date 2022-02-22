//
//  SearchResultViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/17/22.
//

import UIKit
import RealmSwift
protocol SearchResultViewControllerDelegate:AnyObject
{
    func didTapOnMovie(_ cell:SearchResultViewController,model:TitlePreviewViewModel,movieInfo:MovieInfo)
}
class SearchResultViewController: UIViewController,  UISearchBarDelegate {
  //MARK: - Variables
    var movieInfo:MovieInfo?
    var delegate:SearchResultViewControllerDelegate?
    let apiCaller = ApiCaller()
    var model:TitlePreviewViewModel?
    let youtube = YoutubeApi()
    var movieData :[MovieInfo] = [MovieInfo]()
    //MARK: - Outlet
    @IBOutlet weak var collection: UICollectionView!
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }
    

     

}

extension SearchResultViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        guard let query = searchbar.text  ,
        !query.trimmingCharacters(in: .whitespaces).isEmpty
        ,query.trimmingCharacters(in: .whitespaces).count >= 1
        else
        {
            return
        }
        apiCaller.serach(with: query) { result in
            DispatchQueue.main.async {

                switch result
                {
                case .success(let movieData):
                    self.movieData = movieData.results
                    self.collection.reloadData()
                case .failure(let error):
                    print(error)

                }
            }
        }
    }
}

extension SearchResultViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
        collection.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collection.delegate = self
        collection.dataSource = self

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  movieData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! DataCollectionViewCell
        if var title = movieData[indexPath.row].title ?? movieData[indexPath.row].name
                , var poster = movieData[indexPath.row].poster_path
        {
            let model = MovieInfoModel(title: title , posterURL: poster)
            cell.configure(model:model)
        }

        
//        cell.configure(model: movieData[indexPath.row])

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 3 - 10, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("download Tapped")
                RealmFunction.shared.downloadData(movieInfo: self.movieData[indexPath.row])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let title = movieData[indexPath.row].original_title ?? movieData[indexPath.row].original_name, let overView = movieData[indexPath.row].overview
        {
            print(title)
            youtube.fetchYoutubeVideo(query: title+" trailer") { result in
                switch result
                {
                case .success(let movieData):
                    self.model = TitlePreviewViewModel(title: title, youTubeVideo: movieData.items[0].id, overViewTitle: overView)
                    self.movieInfo = self.movieData[indexPath.row]
                    DispatchQueue.main.async {
                        
                        self.delegate?.didTapOnMovie(self, model: self.model!,movieInfo:self.movieInfo!)
                    }
                    print(title+" trailer")
                    print(movieData.items[0].id.videoId)
                case .failure(let error):
                    print(error)
                }
                
            }
            

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = model
        }
    }
    

}
