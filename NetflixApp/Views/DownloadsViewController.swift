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
   
    let downloadViewModel = DownloadViewModel()

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
        downloadViewModel.loadData {
            self.tableView.reloadData()

        }
    }


}
extension DownloadsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadViewModel.itemArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
        downloadViewModel.tableView(cellForRowAt: indexPath) { model in
                        cell.configure(model: model)

        }
//        if let arr = itemArray?[indexPath.row]
//        {
//            let title = arr.title
//            let poster = arr.poster_path
//            let model = MovieInfoModel(title: title, posterURL: poster)
//            cell.configure(model: model)
//
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle
        {
        case .delete:
            downloadViewModel.tableView(forRowAt: indexPath) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
    
         default:
            print("fara7")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        downloadViewModel.tableView(didSelectRowAt: indexPath) {
            DispatchQueue.main.async {
                              self.performSegue(withIdentifier: "downloadToPreview", sender: self)
          
                          }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = self.downloadViewModel.model
        }
    }
    
    
}
