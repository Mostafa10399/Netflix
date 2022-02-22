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
    func collectionTableViewCellDidTabCell(_ cell:CollectionTableViewCell,viewModel:TitlePreviewViewModel,movieInfo:MovieInfo)
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
    //MARK: - DownloadTitleAt
//    func DownloadTitleAt(indexPath : IndexPath)
//    {
//        print("Downloading \(dataArray[indexPath.row].title)")
//        let titleItem = TitleItem()
//
//
//        guard let original_title = dataArray[indexPath.row].original_title ?? dataArray[indexPath.row].original_name ,
//              let poster_path = dataArray[indexPath.row].poster_path,
//              let vote_average = dataArray[indexPath.row].vote_average,
//              let overview = dataArray[indexPath.row].overview,
//              let release_date = dataArray[indexPath.row].release_date ?? dataArray[indexPath.row].first_air_date ,
//              let vote_count = dataArray[indexPath.row].vote_count,
//              let backdrop_path = dataArray[indexPath.row].backdrop_path,
//              let title = dataArray[indexPath.row].title ?? dataArray[indexPath.row].name,
//              let id = dataArray[indexPath.row].id,
//              let popularity = dataArray[indexPath.row].popularity,
//              let original_language = dataArray[indexPath.row].original_language
//        else
//        {
//            return
//        }
//
////        @objc dynamic var original_language:String = ""
//
//
//        titleItem.original_title = original_title
//        titleItem.poster_path = poster_path
//        titleItem.vote_average = vote_average
//        titleItem.overview = overview
//        titleItem.release_date = release_date
//        titleItem.vote_count = Int64(vote_count)
//        titleItem.backdrop_path = backdrop_path
//        titleItem.title = title
//        titleItem.id = Int64(id)
//        titleItem.popularity = popularity
////        titleItem.media_type = mediaType
//        titleItem.original_language = original_language
//       saveData(to: titleItem)
//
//    }
//    func saveData(to titleItem:TitleItem)
//    {
//        do {
//            try CollectionTableViewCell.realm.write {
//                CollectionTableViewCell.realm.add(titleItem)
//               print("iam here")
//               print(dataFilePath)
//            }
//        }
//            catch{
//                fatalError("error")
//            }
//
//    }
    
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
                    let x = TitlePreviewViewModel(title: title, youTubeVideo: dataModel.items[0].id, overViewTitle: overView)
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
//                self.DownloadTitleAt(indexPath: indexPath)
                RealmFunction.shared.downloadData(movieInfo: self.dataArray[indexPath.row])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
  
    
}
