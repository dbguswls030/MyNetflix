//
//  MovieGenreTableViewCell.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/12.
//

import UIKit
import AVFoundation
class MovieGenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    
    var presentDelegate : ((PlayerViewController) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        initCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initCollectionView(){
        let collectionNib = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: "MovieListCell")
    }
    func updateUI(genre: String){
        self.genreLabel.text = genre
    }
    
    func getMovies(genre: String){
        SearchAPI.recommendItemListWithGenre(term: genre) { movies in
            DispatchQueue.main.async {
                self.movies = movies
                print("\(String(describing: self.genreLabel.text)) \(self.movies.count)")
                self.collectionView.reloadData()
            }
            
        }
    }
}




extension MovieGenreTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as? RecommendCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.updateUI(thumbnailPath: URL(string: self.movies[indexPath.row].thumbnailPath)!)
        return cell
    }
}

extension MovieGenreTableViewCell:  UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let item = AVPlayerItem(url: URL(string: movie.preViewURL)!)
        let vc = UIStoryboard(name: "Player", bundle: nil).instantiateViewController(identifier: "Player") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        vc.playerItem = item
        presentDelegate?(vc)
    }
}
extension MovieGenreTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (10 * 2) - (10 * 2))/3 - 10
        let hight = CGFloat(160)
        return CGSize(width: width, height: hight)
    }
}
