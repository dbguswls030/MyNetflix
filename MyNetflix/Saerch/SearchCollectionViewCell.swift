//
//  SearchCollectionViewCell.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
//    func updateUI(movie: Movie){
//        let url = URL(string: movie.thumbnailPath)
//        DispatchQueue.global().async { [weak self] in
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                self?.thumbnailImage.image = UIImage(data: data!)
//            }
//        }
//    }
    func updateUI(url: URL){
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self?.thumbnailImage.image = UIImage(data: data!)
            }
        }
    }
}
