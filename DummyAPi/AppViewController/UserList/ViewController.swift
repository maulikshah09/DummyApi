//
//  ViewController.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var arrUserList : [UserListModel]?
    var currentPage = 0
    var totalPages = 0
    var circularSpinner = TJSpinner()
    
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
        tblUserList.register(cellType: LoadMoreTableViewCell.self, bundle: nil)
        
        circularSpinner = TJSpinner.init(spinnerType: "TJCircularSpinner")
    }
}

//MARK:-  ----------- Tableview Methods -------------
extension ViewController : UITableViewDelegate,UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if (currentPage < totalPages){
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrUserList?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return userListCell(indexPath: indexPath)
        }else{
            self.callWebservice(#selector(self.getUserList), forTarget: self)
            return loadingCell(indexPath: indexPath)
        }
    }
    
    func userListCell(indexPath : IndexPath) -> UserCell{
        let cell = tblUserList.dequeueReusableCell(with: UserCell.self, for: indexPath)
        cell.setUserInfo(info: arrUserList?[indexPath.row] ?? UserListModel())
        cell.selectionStyle = .none
        return cell
    }
    
    func loadingCell(indexPath: IndexPath) -> LoadMoreTableViewCell {
    
        let cell = self.tblUserList.dequeueReusableCell(with:LoadMoreTableViewCell.self , for: indexPath)
                                        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear

        circularSpinner.hidesWhenStopped = false
        circularSpinner.radius = 10

        circularSpinner.pathColor = UIColor.white
        circularSpinner.fillColor = UIColor.themeOrange()
            
        circularSpinner.thickness = 5
        circularSpinner.frame = CGRect(x: view.bounds.size.width / 2 - 15, y: 5, width: circularSpinner.frame.size.width, height: circularSpinner.frame.size.height)
        circularSpinner.backgroundColor = UIColor.clear
        cell.addSubview(circularSpinner)
        circularSpinner.startAnimating()
        cell.selectionStyle = .none
        return cell
    }
}



//MARK:-  ----------- Api Calling -------------
extension ViewController {
    @objc func getUserList() {
        
        let myUrl = URL(string: AppUrls.getUserList.raw)
        var components = URLComponents(url: myUrl!, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "page" , value: "\(self.currentPage)")
        ]
        
        URLSession.shared.request(url:  components?.url?.absoluteString ?? "", isShowHUD: self.currentPage == 0 ? true : false, headerInfo: headerInfo, method: .get, parmeters:nil , decodeClass: UserModel.self) {[weak self] response, error in
            if let res = response{
                if res.data?.count ?? 0 > 0 {
                    if self?.currentPage == 0 {
                        self?.arrUserList = res.data ?? [UserListModel]()
                    }else{
                        self?.arrUserList?.append(contentsOf: res.data ?? [UserListModel]())
                    }
                    self?.currentPage = (self?.currentPage ?? 0) + 1
                    self?.totalPages = res.total ?? 0
                }else{
                    // list done
                    self?.currentPage = self?.totalPages ?? 0
                }
                DispatchQueue.main.async {
                    self?.tblUserList.reloadData()
                }
            }else{
                print(AppMessage.somthingWantWrng.localized)
            }
        }
    }
}
