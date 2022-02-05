//
//  PostDetailVC.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit

class PostDetailVC: UIViewController {
    var info : PostListModel?
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblPostName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgPost.clipsToBounds = true
        self.imgPost.layer.cornerRadius = self.imgPost.frame.size.height / 2
        if let _ = info {
            callWebservice(#selector(getPostbyId), forTarget: self)
            self.btnDelete.isEnabled = true
            self.btnDelete.tintColor = UIColor.themeBlue()
            self.btnDelete.target = self
            self.btnDelete.action = #selector(deletePostByid)
        }else{
           
            self.btnDelete.isEnabled = false
            self.btnDelete.tintColor = .clear
        }
        // Do any additional setup after loading the view.
    }
}

//MARK:-  ----------- Api Calling -------------
extension PostDetailVC {
    @objc func getPostbyId() {
        
        URLSession.shared.request(url: BASE_URL + "post/\(info?.id ?? "0")", isShowHUD: true, headerInfo: headerInfo, method: .get, parmeters:nil , decodeClass: PostListModel.self) {[weak self] response, error in
            DispatchQueue.main.async {
                if let response = response{
                    
                    let url = URL(string: response.image ?? "")
                    self?.imgPost.sd_setImage(with:url , placeholderImage: UIImage(named: "ic_UserPlaceHolder"))
                    self?.lblPostName.text = response.text ?? ""
                }else{
                    print(AppMessage.somthingWantWrng.localized)
                }
            }
        }
    }
  
    @objc func deletePostByid() {
        if isConnected(){
            URLSession.shared.request(url: BASE_URL + "post/\(info?.id ?? "0")", isShowHUD: true, headerInfo: headerInfo, method: .delete, parmeters:nil , decodeClass: PostModel.self) {[weak self] response, error in
                DispatchQueue.main.async {
                    if let _ = response{
                        
                        self?.navigationController?.popViewController(animated: false)
                    }
                    else{
                        print(AppMessage.somthingWantWrng.localized)
                    }
                }
            }
        }
    }
}
