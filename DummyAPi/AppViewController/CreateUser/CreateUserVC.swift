//
//  CreateUserVC.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit

class CreateUserVC: UIViewController {

     
    var userInfo : UserListModel?
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCreateorUpdate: AppButton!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
        if let _ = userInfo{
            callWebservice(#selector(getUser), forTarget: self)
            self.btnCreateorUpdate.setTitle(AlertTitle.updateUser.localized, for: .normal)
            self.btnDelete.isEnabled = true
            self.btnDelete.tintColor = UIColor.themeBlue()
            self.btnDelete.target = self
            self.btnDelete.action = #selector(deleteUser)
        }else{
            self.btnCreateorUpdate.setTitle(AlertTitle.createUser.localized, for: .normal)
            self.btnDelete.isEnabled = false
            self.btnDelete.tintColor = .clear
        }
    }
   
    @IBAction func btnCreateUpdatePress(_ sender: Any) {
        self.view.endEditing(true)
        if txtFirstName.text?.trim == ""{
            showAlert(AppMessage.firstName.localized)
        }else if txtLastName.text?.trim == ""{
            showAlert(AppMessage.lastName.localized)
        }else if txtEmail.text?.trim == ""{
            showAlert(AppMessage.email.localized)
        }else{
            if let  _ =  userInfo{
                callWebservice(#selector(updateUser), forTarget: self)
            }else{
                callWebservice(#selector(createUser), forTarget: self)
            }
        }
    }
}



//MARK:-  ----------- Api Calling -------------
extension CreateUserVC {
    @objc func createUser() {
        let parms = [
            "firstName" : self.txtFirstName.text ?? "",
            "lastName" : self.txtLastName.text ?? "",
            "email" : self.txtEmail.text ?? ""
        ]

        URLSession.shared.request(url: AppUrls.createUser.raw, isShowHUD: true, headerInfo: headerInfo, method: .post, parmeters: parms, decodeClass: UserListModel.self) { res, erro in
            if let _ = res {
                DispatchQueue.main.async {
                    self.backBtnPress()
                }
            }
        }
    }
    
    @objc func updateUser(){
        let parms = [
            "firstName" : self.txtFirstName.text ?? "",
            "lastName" : self.txtLastName.text ?? "",
            "email" : self.txtEmail.text ?? ""
        ]

        URLSession.shared.request(url: AppUrls.getUserList.raw + "/\(userInfo?.id ?? "")", isShowHUD: true, headerInfo: headerInfo, method: .put, parmeters: parms, decodeClass: UserListModel.self) { res, erro in
            if let _ = res {
                DispatchQueue.main.async {
                    self.backBtnPress()
                }
            }
        }
    }
    
    
    @objc func getUser(){
        URLSession.shared.request(url: AppUrls.getUserList.raw + "/\(userInfo?.id ?? "")", isShowHUD: true, headerInfo: headerInfo, method: .get, parmeters: nil, decodeClass: UserListModel.self) { res, erro in
            if let res = res {
                DispatchQueue.main.async {
                    self.txtFirstName.text = res.firstName ?? ""
                    self.txtLastName.text = res.lastName ?? ""
                    self.txtEmail.text = res.email ?? ""
                }
            }
        }
    }
    
    @objc func deleteUser(){
        if isConnected(){
            URLSession.shared.request(url: AppUrls.getUserList.raw + "/\(userInfo?.id ?? "")", isShowHUD: true, headerInfo: headerInfo, method: .delete, parmeters: nil, decodeClass: UserListModel.self) { res, erro in
                if let _ = res {
                    DispatchQueue.main.async {
                        self.backBtnPress()
                    }
                }
            }
        }
    }
}
