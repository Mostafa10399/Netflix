//
//  DownloadsViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/20/22.
//

import UIKit
import RealmSwift
class DownloadsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var youtubeApi = YoutubeApi()
    var itemArray:Results<TitleItem>?
    var model:TitlePreviewViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //downloadToPreview
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.white
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpComingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpComingTableViewCell")
        
    }
    

    func loadData()
    {
        itemArray = realm.objects(TitleItem.self)
        tableView.reloadData()
    }


}
extension DownloadsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
        if let arr = itemArray?[indexPath.row]
        {
            let title = arr.title
            let poster = arr.poster_path
            let model = MovieInfoModel(title: title, posterURL: poster)
            cell.configure(model: model)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle
        {
        case .delete:
            do
            {
                guard let item = itemArray?[indexPath.row] else
                {
                    return
                }
                try realm.write {
                    realm.delete(item)
                    tableView.deleteRows(at: [indexPath], with: .fade)

                }
            }
            catch
            {
                print(error)
            }
    
         default:
            print("fara7")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = itemArray?[indexPath.row].title ,let overView = itemArray?[indexPath.row].overview else
        {
            return
        }
        youtubeApi.fetchYoutubeVideo(query: title+" trailer") { result in
            switch result
            {
            case .success(let youtubeViewModel):
                self.model = TitlePreviewViewModel(title: title, youTubeVideo: youtubeViewModel.items[0].id, overViewTitle: overView)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "downloadToPreview", sender: self)

                }

            case .failure(let error):
                print(error)

            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = self.model
        }
    }
    
    
}
