//
//  HomeViewController.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import UIKit

class HomeViewController: UIViewController {
    // 장르별 collectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? MovieCollectionReusableView else{
                return UICollectionReusableView()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // MARK: 헤더 사이즈 조절
        let width = collectionView.bounds.width
//        let indexPath = IndexPath(row: 0, section: section)
//        guard let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? BoardCollectionReusableView else{
//            return CGSize(width: width, height: 401.5)
//        }
//        let profileImage = header.profileImage.bounds.height
//
//        let content = header.contents.bounds.height
//        let commentLabel = header.commentCount.bounds.height
//
//        let height = 15 + profileImage + 15 + 1 + 20 + content + 15 + 25 + 1 + 3 + commentLabel + 3 + 1
//        return CGSize(width: width, height: height)
        
        return CGSize(width: width, height: 500)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        // MARK: 셀 사이즈 조절
        return CGSize(width: width, height: 160)
    }
    
}
