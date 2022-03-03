//
//  CollectionTableViewCell.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/12/22.
//

import UIKit
import RealmSwift
protocol CollectionTableViewCellDelegate:AnyObject
{
    func collectionTableViewCellDidTabCell(_ cell:CollectionTableViewCell,viewModel:TitlePreviewModel,movieInfo:MovieInfo)
}

class CollectionTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TitleItem.plist")

    //MARK: - variables
    var delegate:CollectionTableViewCellDelegate?
    let youtubeApi = YoutubeApi()
    var dataArray = [MovieInfo]()
    
    static var realm = try! Realm()
    //MARK: - IBOutlets
    @IBOutlet weak var collection: UICollectionView!
    //MARK: - Awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collection.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collection.delegate = self
        collection.dataSource = self
        contentView.backgroundColor = .systemBackground
    }
    
//MARK: - set Selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Number of Items In Sections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArray.count
    }
    //MARK: - Cell for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! DataCollectionViewCell
        guard let title = dataArray[indexPath.row].title ?? dataArray[indexPath.row].name , let poster = dataArray[indexPath.row].poster_path else
        {
            return UICollectionViewCell()
        }
        let model = MovieInfoModel(title: title, posterURL: poster)
        cell.configure(model: model)
        
        return cell
    }
    //MARK: - Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    //MARK: - Did Select item at
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let title = dataArray[indexPath.row].original_title ?? dataArray[indexPath.row].original_name,let overView = dataArray[indexPath.row].overview
        {
            print(title)
            youtubeApi.fetchYoutubeVideo(query: title+" trailer") { result in
                switch result
                {
                case .success(let dataModel):
                    let movieInfo =  self.dataArray[indexPath.row]
                    let x = TitlePreviewModel(title: title, youTubeVideo: dataModel.items[0].id, overViewTitle: overView)
                    self.delegate?.collectionTableViewCellDidTabCell(self, viewModel: x,movieInfo: movieInfo)
                case .failure(let error):
                   fatalError("\(error)")
                }
            }
        }
        
    }
    //MARK: - Configure Section
    func ConfigureSection(model:[MovieInfo])
    {
        dataArray = model
        
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    //MARK: - Long tapped
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil,  state: .off) { _ in
                print("Download Taped")
                RealmFunction.shared.downloadData(movieInfo: self.dataArray[indexPath.row])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
  
    
}
