//
//  RecommendCollectionViewCell.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/12.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieThumnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(thumbnailPath: URL){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: thumbnailPath)
            DispatchQueue.main.async {
                self.movieThumnail.image = UIImage(data: data!)
                self.movieThumnail.layer.cornerRadius = 3
            }
        }  
    }
}
