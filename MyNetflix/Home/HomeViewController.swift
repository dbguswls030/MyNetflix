//
//  HomeViewController.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    // 장르별 collectionView
    var movie: Movie?
    @IBOutlet weak var headerThumbnail: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initThumbnail()
        tableView.dataSource = self
        tableView.delegate = self
        initTableView()
    }
    
    @IBAction func playButton(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        let item = AVPlayerItem(url: URL(string: movie.preViewURL)!)
        let vc = UIStoryboard(name: "Player", bundle: nil).instantiateViewController(identifier: "Player") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        vc.playerItem = item
        self.present(vc, animated: false)
    }
    
    func initThumbnail(){
        SearchAPI.recommendOneItem { movies in
            self.movie = movies.first!
            let url = URL(string: self.movie!.thumbnailPath)!
            self.updateUI(url: url)
        }
    }
    func updateUI(url: URL){
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self?.playButton.layer.cornerRadius = 2
                self?.headerThumbnail.image = UIImage(data: data!)
            }
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func initTableView(){
        let tableNib = UINib(nibName: "MovieGenreTableViewCell", bundle: nil)
        self.tableView.register(tableNib, forCellReuseIdentifier: "MovieGenreList")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchAPI.movieGenre.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreList") as? MovieGenreTableViewCell else{
            return UITableViewCell()
        }
        
        cell.getMovies(genre: SearchAPI.movieGenre[indexPath.row])
        cell.updateUI(genre: SearchAPI.movieGenre[indexPath.row])
        cell.presentDelegate = { vc in
            self.present(vc, animated: false)
        }
        return cell
    }
}


// MARK: Header에 추천 영상 띄우기

// MARK: tableView에 CollectionView 넣기


//extension HomeViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return SearchAPI.movieGenre.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieList", for: indexPath) as? MovieCollectionViewCell else{
//            return UICollectionViewCell()
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind{
//        case UICollectionView.elementKindSectionHeader:
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderMovie", for: indexPath) as? MovieCollectionReusableView else{
//                return UICollectionReusableView()
//            }
//            header.getThumbnail()
//            header.delegate = { vc in
//                self.present(vc, animated: false)
//            }
//            return header
//        default:
//            return UICollectionReusableView()
//        }
//    }
//}
//
