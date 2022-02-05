//
//  AppButton.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
 

class AppButton: UIButton {
  
    init() {
        super.init(frame: UIScreen.main.bounds)
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

         disableEffect()
    }
    
    func disableEffect() {
        
        if let gradientLayer = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
               gradientLayer.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 5
        let frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        gradient.frame = frame
        gradient.colors = [UIColor.themeOrange().withAlphaComponent(0.5).cgColor,UIColor.themeBlue().withAlphaComponent(0.5).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
        self.setTitleColor(.white, for: .normal)
    }
}

