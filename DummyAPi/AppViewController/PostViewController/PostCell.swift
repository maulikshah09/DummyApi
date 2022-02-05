//
//  PostCell.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var lblPostName: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var cvTags: UICollectionView!
    @IBOutlet weak var imgPost: UIImageView!
    
    var arrTags = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgPost.layer.cornerRadius = self.imgPost.frame.size.height / 2
        self.imgPost.layer.borderWidth = 1
        self.imgPost.layer.borderColor = UIColor.orange.cgColor
        self.cvTags.register(cellType:TagCell.self, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPost(info : PostListModel) {
        let url = URL(string: info.image ?? "")
        self.imgPost.sd_setImage(with:url , placeholderImage: UIImage(named: "ic_UserPlaceHolder"))
        self.lblPostName.text = info.text ?? ""
        self.lblLikes.text = "\(info.likes ?? 0.0)"
        arrTags = info.tags ?? [String]()
        self.cvTags.reloadData()
    }
}

extension PostCell : UICollectionViewDelegate,UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvTags.dequeueReusableCell(with: TagCell.self, for: indexPath)
        cell.lblTags.text = arrTags[indexPath.item]
        return cell
    }
}
