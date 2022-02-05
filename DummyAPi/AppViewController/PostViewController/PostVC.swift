//
//  ViewController.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
 
class PostVC: UIViewController {
    
    var info : UserListModel?
    var arrPostList : [PostListModel]?
    var currentPage = 0
    var totalPages = 0
    var circularSpinner = TJSpinner()
    var isUpdate = false
    
   // @IBOutlet weak var btnCreateUser: AppButton!
    @IBOutlet weak var tblPost: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPage = 0
        callWebservice(#selector(getPostList), forTarget: self)
    }
  
    @IBAction func btnCreateUserPress(_ sender: Any) {
        info = nil
        self.performSegue(withIdentifier: CreateUserVC.className, sender: self)
    }
}

// MARK:-  ----------- Functions -------------
extension PostVC {
    func setup(){
        self.title = AppNavigationTitle.ListUser.localized
        tblPost.register(cellType: PostCell.self, bundle: nil)
        tblPost.register(cellType: LoadMoreTableViewCell.self, bundle: nil)
        
        circularSpinner = TJSpinner.init(spinnerType: "TJCircularSpinner")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CreateUserVC.className {
            let detail = segue.destination as? CreateUserVC
            detail?.userInfo = info
        }
    }
    
    @objc func viewProfile(sender : UIButton){
     //   info = arrPostList?[sender.tag]
        self.performSegue(withIdentifier:CreateUserVC.className , sender: self)
    }
    
    @objc func viewPost(sender : UIButton){
        
    }
}

//MARK:-  ----------- Tableview Methods -------------
extension PostVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
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
            return arrPostList?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return userListCell(indexPath: indexPath)
        }else{
            self.callWebservice(#selector(self.getPostList), forTarget: self)
            return loadingCell(indexPath: indexPath)
        }
    }
    
    func userListCell(indexPath : IndexPath) -> PostCell{
        let cell = tblPost.dequeueReusableCell(with: PostCell.self, for: indexPath)
        cell.setupPost(info: arrPostList?[indexPath.row] ?? PostListModel())
        cell.selectionStyle = .none
        return cell
    }
   
    func loadingCell(indexPath: IndexPath) -> LoadMoreTableViewCell {
    
        let cell = self.tblPost.dequeueReusableCell(with:LoadMoreTableViewCell.self , for: indexPath)
                                        
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
extension PostVC {
    @objc func getPostList() {
        
        let myUrl = URL(string: BASE_URL + "user/\(info?.id ?? "0")/post")
        var components = URLComponents(url: myUrl!, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "page" , value: "\(self.currentPage)")
        ]
        
        URLSession.shared.request(url:  components?.url?.absoluteString ?? "", isShowHUD: self.currentPage == 0 ? true : false, headerInfo: headerInfo, method: .get, parmeters:nil , decodeClass: PostModel.self) {[weak self] response, error in
            if let res = response{
                if res.data?.count ?? 0 > 0 {
                    if self?.currentPage == 0 {
                        self?.arrPostList = res.data ?? [PostListModel]()
                    }else{
                        self?.arrPostList?.append(contentsOf: res.data ?? [PostListModel]())
                    }
                    self?.currentPage = (self?.currentPage ?? 0) + 1
                    self?.totalPages = res.total ?? 0
                }else{
                    // list done
                    self?.currentPage = self?.totalPages ?? 0
                }
                DispatchQueue.main.async {
                    self?.tblPost.reloadData()
                }
            }else{
                print(AppMessage.somthingWantWrng.localized)
            }
        }
    }
}
