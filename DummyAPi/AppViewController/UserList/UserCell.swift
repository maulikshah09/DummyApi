//
//  UserCell.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var btnViewInfo: UIButton!
    @IBOutlet weak var btnUserPost: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outterView.layer.masksToBounds = false
        self.outterView.layer.cornerRadius = 12
       
        self.outterView.layer.shadowColor = UIColor.lightGray.cgColor
        self.outterView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.outterView.layer.shadowOpacity = 0.7
        self.outterView.layer.shadowRadius = 4.0
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height / 2
        self.imgUser.layer.borderWidth = 1
        self.imgUser.layer.borderColor = UIColor.orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUserInfo(info : UserListModel) {
        self.lblFirstName.text = info.firstName
        self.lblLastName.text = info.lastName
        let url = URL(string: info.picture ?? "")
        self.imgUser.sd_setImage(with:url , placeholderImage: UIImage(named: "ic_UserPlaceHolder"))
    }
}
