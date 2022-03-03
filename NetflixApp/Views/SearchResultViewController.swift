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
    func didTapOnMovie(_ cell:SearchResultViewController,model:TitlePreviewModel,movieInfo:MovieInfo)
}
class SearchResultViewController: UIViewController,  UISearchBarDelegate {
  //MARK: - Variables
    let searchResult = SearchResultViewModel()
    var delegate:SearchResultViewControllerDelegate?
 
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
        guard let query = searchbar.text
        else
        {
            return
        }
        searchResult.updateSearchResults(query: query) {
            self.collection.reloadData()
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
        return  searchResult.collectionView(numberOfItemsInSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! DataCollectionViewCell
        searchResult.collectionView(cellForItemAt: indexPath) { model in
            if let model = model  {
                cell.configure(model:model)
                
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 3 - 10, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("download Tapped")
                self.searchResult.downloadMovie(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchResult.collectionView(didSelectItemAt: indexPath) {
            DispatchQueue.main.async {
                
                self.delegate?.didTapOnMovie(self, model: self.searchResult.model!,movieInfo:self.searchResult.movieInfo!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = searchResult.model
        }
    }
    

}
