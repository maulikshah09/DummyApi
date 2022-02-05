 
import UIKit
import SystemConfiguration
//import Alamofire
 
 
private func _swizzling(forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    
    if let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}


//perfect for debug
func printDebug(object: Any) {
    #if DEBUG
    print(object)
    #endif
}

// 2 - print array 
func printArray<T>(_ array: [T]) {
    #if DEBUG
    for item in array {
        print(item)
    }
    #endif
}
 
// 2 - In Action
//printArray(strings)
//printArray(integers)


func NoInternet(){
     showAlert(AppMessage.noInternet.localized)
}
 
 //MARK: Alerts
 func showAlert(_ message: String, position: HRToastPosition = HRToastPosition.Default)
 {
     if message.count > 0 {
         DispatchQueue.main.async(execute: {
             APPDELEGATE.window!.makeToast(message: message , duration: 2, position: position)
         })
     }
 }

 
 extension UIViewController{
  
     var navigationBarHeight: CGFloat {
        let navHeight = getNavigationBarHeight
        let statusBarHeight = getStatusBarHeight
        
         return statusBarHeight + navHeight + 20
     }
    
     
     var getNavigationBarHeight: CGFloat{
         return navigationController?.navigationBar.frame.size.height ?? 44.0
     }
     
     var getStatusBarHeight:CGFloat {
         var statusBarHeight : CGFloat = 0.0
         if #available(iOS 13.0, *) {
             let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
             statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
         } else {
             statusBarHeight = UIApplication.shared.statusBarFrame.height
         }
         
         return statusBarHeight
     }
     
     
     
     var isModal: Bool {
         
         let presentingIsModal = presentingViewController != nil
         let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
         let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
         
         return presentingIsModal || presentingIsNavigation || presentingIsTabBar
     }
     
 
     func callWebservice(_ webservice: Selector, forTarget target: Any?) {
         if (NetworkReachabilityManager()?.isReachable ?? true) {
             self.perform(webservice, with: nil, afterDelay: 0.0001)
         } else {
             NoInternet()
         }
     }
     
    
     func isConnected() -> Bool {
         if (NetworkReachabilityManager()?.isReachable ?? true) {
              return true
         }
         return false
     }
     
     @objc func backBtnPress() {
         self.navigationController?.popViewController(animated: true)
     }
     
    // when keyboard when tap on outside
    func hideKeyBoardWhenTapAround() {
        let tapAround = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        tapAround.numberOfTapsRequired = 1
        tapAround.cancelsTouchesInView = false
        view.addGestureRecognizer(tapAround)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    func showNoDataFoundImage(imageName : String = "ic_no_Result_found") {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imgView.center = self.view.center
        imgView.tag = 12345
        imgView.image = UIImage(named:  imageName)
        self.view.addSubview(imgView)
    }


    func hideNoDataFoundImage() {
        for imgView in self.view!.subviews {
            if imgView.tag == 12345 {
                imgView.removeFromSuperview()
            }
        }
    }
  
    
    
    //delay method
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // remove present style from ios13
    static func preventPageSheetPresentationStyle () {
        UIViewController.preventPageSheetPresentation
    }
    
    static let preventPageSheetPresentation: Void = {
        if #available(iOS 13, *) {
            _swizzling(forClass: UIViewController.self,
                       originalSelector: #selector(present(_: animated: completion:)),
                       swizzledSelector: #selector(_swizzledPresent(_: animated: completion:)))
        }
    }()
    
    @objc @available(iOS 13.0, *)
    private func _swizzledPresent(_ viewControllerToPresent: UIViewController,
                                  animated flag: Bool,
                                  completion: (() -> Void)? = nil) {
        if viewControllerToPresent.modalPresentationStyle == .pageSheet
            || viewControllerToPresent.modalPresentationStyle == .automatic {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        _swizzledPresent(viewControllerToPresent, animated: flag, completion: completion)
    }

    func openURL(url : String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

}

//Project common Methods
extension UIViewController {
    
//    func showStingPicker(title:String,
//                         rowValues:[Any],
//                         initialSelectionValue: Int,
//                         originType : Any,
//                         _ completion: @escaping(_ values:Any?,_ indexes:Any?) -> Void){
//
//        let actionStringPicker = ActionSheetStringPicker(title: title, rows: rowValues, initialSelection: initialSelectionValue, doneBlock: { picker, indexes, values in
//            completion(values,indexes)
//        }, cancel: { ActionSheetStringPicker in return
//        }, origin:originType)
//
//        actionStringPicker?.pickerBackgroundColor = .white
//        actionStringPicker?.toolbarButtonsColor =  THEME_COLOR
//        actionStringPicker?.toolbarBackgroundColor = .white
//        actionStringPicker?.show()
//    }
     
//    func showDatePicker(title:String,
//                        datePickerModeof: UIDatePicker.Mode = UIDatePicker.Mode.date,
//                        previousSelected: Date? = nil,
//                        minimumDate : Date? = nil,
//                        maximumDate : Date? = nil,
//                        originType : UIView,
//                        _ completion: @escaping(_ date:Any?) -> Void){
//
//        let datePicker = ActionSheetDatePicker(title: title.localized,
//                                               datePickerMode: datePickerModeof,
//                                               selectedDate: previousSelected,
//                                               doneBlock: { picker, date, origin in
//                                                completion(date)
//                                                return
//        },
//                                               cancel: { picker in
//                                                return
//        },
//                                               origin: originType)
//
//
//
//        if let maxdate = maximumDate {
//            datePicker?.maximumDate = maxdate
//        }
//
//        if let minDate = minimumDate {
//             datePicker?.minimumDate = minDate
//        }
//
//        datePicker?.pickerBackgroundColor = .white
//        datePicker?.toolbarButtonsColor = THEME_COLOR
//        datePicker?.toolbarBackgroundColor = .white
//       // datePicker?.locale = Locale(identifier: Bundle.currentAppleLanguage())
//        datePicker?.show()
//    }
//
    
    //MARK:show String Picker
   
    
//    //MARK:Activity View Controller
//    func shareYourItems(shareItems:Array<Any>,isexcludItems:Bool,excludItems:Array<UIActivity.ActivityType>) -> Void {
//        let avc = UIActivityViewController(activityItems:shareItems , applicationActivities: []);
//
//        if isexcludItems
//        {
//            if (!excludItems.isEmpty)
//            {
//                avc.excludedActivityTypes = excludItems;
//            }
//        }
//        present(avc, animated: true);
//    }
//
   
}
  

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popToViewControllerOrRoot(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }else{
            popToRootViewController(animated: true)
        }
    }
}

