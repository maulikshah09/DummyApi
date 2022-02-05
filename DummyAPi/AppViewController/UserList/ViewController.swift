//
//  ViewController.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var arrUserList : [UserListModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tblUserList.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tblUserList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK:-  ----------- Functions -------------
extension ViewController {
    func setup(){
        self.title = AppNavigationTitle.ListUser.localized
        callWebservice(#selector(getUserList), forTarget: self)
        tblUserList.register(cellType: UserCell.self, bundle: nil)
    }
}

//MARK:-  ----------- Tableview Methods -------------
extension ViewController : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return userListCell(indexPath: indexPath)
    }
    
    func userListCell(indexPath : IndexPath) -> UserCell{
        let cell = tblUserList.dequeueReusableCell(with: UserCell.self, for: indexPath)
        cell.setUserInfo(info: arrUserList?[indexPath.row] ?? UserListModel())
        cell.selectionStyle = .none
        return cell
    }
}



//MARK:-  ----------- Api Calling -------------
extension ViewController {
    @objc func getUserList() {
        URLSession.shared.request(url: AppUrls.getUserList.raw, isShowHUD: true, headerInfo: headerInfo, method: .get, parmeters:nil , decodeClass: UserModel.self) {[weak self] response, error in
            if let res = response{
                if res.data?.count ?? 0 > 0 {
                    self?.arrUserList = res.data ?? [UserListModel]()
                }else{
                    // list done
                }
            }else{
                print(AppMessage.somthingWantWrng.localized)
            }
        }
    }
}
