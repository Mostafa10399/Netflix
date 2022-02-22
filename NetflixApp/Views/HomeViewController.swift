//
//  ViewController.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 2/12/22.
//

import UIKit
import SDWebImage
import RealmSwift
enum Sections:Int
{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case UpComingMovies = 3
    case TopRated = 4
    
}

class HomeViewController: UIViewController {
    //MARK: - variable
    let sectionTitles :[String] = ["Trending Movies","Trending TV","Popular","Upcoming Movies","Top Rated"]
    var model:TitlePreviewViewModel?
    var apiCaller = ApiCaller()
    var randomMovie:MovieInfo?
    let youtube = YoutubeApi()
    var movieInfo:MovieInfo?
    var ModelArray : [MovieInfo]?
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var headerView: UIView!

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let gestur = UITapGestureRecognizer(target: self, action:#selector (headerPressed))
        headerView.addGestureRecognizer(gestur)
    }
    
    //MARK: - HeaderPressed
    @objc func headerPressed()
    {
        guard let name = randomMovie?.title , let overView = randomMovie?.overview else
        {
            return
        }
        youtube.fetchYoutubeVideo(query: name + " tariler") { result in
            switch result
            {
            case .success(let youtubeDataModel):
                self.model = TitlePreviewViewModel(title: name , youTubeVideo:youtubeDataModel.items[0].id, overViewTitle:overView )
                self.movieInfo = self.randomMovie
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"homeToInfo", sender: self)

                }
            case .failure(let error):
                print(error)
            }
        }
        
//
     
    }
   
    @IBAction func downloadButtonPressed(_ sender: UIButton) {

        guard let randomMovie = randomMovie else {
            return
        }

        RealmFunction.shared.downloadData(movieInfo: randomMovie)
        
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let name = randomMovie?.title , let overView = randomMovie?.overview else
        {
            return
        }
        youtube.fetchYoutubeVideo(query: name + " tariler") { result in
            switch result
            {
            case .success(let youtubeDataModel):
                self.model = TitlePreviewViewModel(title: name , youTubeVideo:youtubeDataModel.items[0].id, overViewTitle:overView )
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"homeToInfo", sender: self)

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func configurePoster()
    {
        apiCaller.fetchDataForMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                
                if let movie = movieDataModel.results.randomElement(),let imageUrl = movie.poster_path , let title = movie.title
                {
                    self.randomMovie = movie
                    let model = MovieInfoModel(title: title, posterURL: imageUrl)
                    guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else
                         {
                             return
                         }
                    self.posterImage.sd_setImage(with: url, completed: nil)


                }
            case .failure(let error):
                print(error)
            }
        }
   
     
     
        
    }
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           navigationController?.navigationBar.shadowImage = UIImage()
           navigationController?.navigationBar.isTranslucent = true
           navigationController?.view.backgroundColor = .clear
        super.viewWillAppear(animated)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 1)
        setUPButtonShape()
        setUpNavigation()
        configurePoster()
    }
}
//MARK: - TableViewDelegate And DataSource


extension HomeViewController:CollectionTableViewCellDelegate
{
    
    
    func collectionTableViewCellDidTabCell(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel, movieInfo: MovieInfo) {
      model = viewModel
      self.movieInfo=movieInfo
        DispatchQueue.main.async {
        
            self.performSegue(withIdentifier: "homeToInfo", sender: self)
       
    }
        
    
    
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TitlePreviewViewController
        {
            destination.previewModel = model
            destination.movieInfo = movieInfo
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOfsets = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOfsets
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
        
    }
    func setUPButtonShape()
    {
        playButton.layer.backgroundColor = UIColor.black.cgColor
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.cornerRadius = 5
        downloadButton.layer.backgroundColor = UIColor.black.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.cornerRadius = 5
        setUpNavigation()
       
    }
    func setUpNavigation() {
      
        let logoImage = UIImage.init(named: "netflixLogo")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:50,height:50.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 35)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 35)
         heightConstraint.isActive = true
         widthConstraint.isActive = true
         navigationItem.leftBarButtonItem =  imageItem
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
          

        ]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource
{
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2.5)
        tableView.tableHeaderView = headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        cell.delegate = self
        switch indexPath.section
        {
        case Sections.TrendingMovies.rawValue:
            apiCaller.fetchDataForMovies { result in
                
                switch result
                {
                case .success(let movieDataModel):
                    cell.ConfigureSection(model:movieDataModel.results)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.TrendingTv.rawValue:
            apiCaller.fetchDataForTV { result in
                switch result
                {
                case .success(let movieDataModel):
                    cell.ConfigureSection(model:movieDataModel.results)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.Popular.rawValue:
            apiCaller.fetchDataForPopularMovies { result in
                switch result
                {
                case .success(let movieDataModel):
                    cell.ConfigureSection(model:movieDataModel.results)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.UpComingMovies.rawValue:
            apiCaller.fetchDataForUpComingMovies { result in
                switch result
                {
                case .success(let movieDataModel):
                    cell.ConfigureSection(model:movieDataModel.results)
                case .failure(let error):
                    print(error)
                }
            }

        case Sections.TopRated.rawValue:
            apiCaller.fetchDataForTopRatedMovies { result in
            switch result
            {
            case .success(let movieDataModel):
                cell.ConfigureSection(model:movieDataModel.results)
            case .failure(let error):
                print(error)
            }
        }
        default:
            return UITableViewCell()
        }
        
       
        return cell
    }
    //MARK: - Table Header View
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView
        {
            header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            header.textLabel?.frame = CGRect(x: header.bounds.origin.x , y: header.bounds.origin.y , width: 100, height: header.bounds.height)
            header.textLabel?.textColor = .white
            header.textLabel?.text = header.textLabel?.text?.capitalize()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
   
}
extension String {
    func capitalize() -> String {
        let arr = self.split(separator: " ").map{String($0)}
        var result = [String]()
     
        
        for element in arr {
            let lowerCasedString = element.lowercased()
            result.append( lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased()))
        }
        return result.joined(separator: " ")
    }
    
    
    
}
