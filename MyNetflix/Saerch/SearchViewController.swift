//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import UIKit
import AVFoundation
class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let movieListViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        initSearchBar()
    }

}


extension SearchViewController: UISearchBarDelegate{
    func initSearchBar(){
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // MARK: 서치 동작 작성
        dismissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else{
            return
        }
        SearchAPI.search(term: searchTerm) { movies in
            print("몇 개 넘어 왔나 --> \(movies.count) 개")
            DispatchQueue.main.async {
                self.movieListViewModel.loadMovie(movies: movies)
                self.collectionView.reloadData()
            }
        }
    }
}
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieListViewModel.getMovie(index: indexPath.item)
        let item = AVPlayerItem(url: URL(string: movie.preViewURL)!)
        let vc = UIStoryboard(name: "Player", bundle: nil).instantiateViewController(identifier: "Player") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        vc.playerItem = item
        self.present(vc, animated: false)
        
    }
}

extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? SearchCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.updateUI(url: URL(string: movieListViewModel.getMovie(index: indexPath.item).thumbnailPath)!)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListViewModel.numOfSection
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = CGFloat(8)
        let inset = CGFloat(10)
        let width = (collectionView.bounds.width - margin * 2 - inset * 2) / 3
        let height = width * 10 / 7
        return CGSize(width: width, height: height)
    }
}
