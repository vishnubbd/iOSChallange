//
//  ShowListAlertViewViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/25/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

//MARK: - Add UiAlertviewcontroller
extension UIViewController {
        
        func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (String) -> Void) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (_, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(option)
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
//MARK: - extension for navigation bar color
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //MARK: - extension for navigation bar Size and Font family
    func defaultNavigationItem(navigationBar:UINavigationBar){
        navigationBar.barTintColor = self.hexStringToUIColor(hex: "5A35F5")
        navigationBar.prefersLargeTitles = false
    }
    func largeTitleNavigationItem(navigationBar:UINavigationBar){
        navigationBar.barTintColor = self.hexStringToUIColor(hex: "5AFFF5")
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.font: UIFont(name: GEN_STRINGS.FONT_FAMILY, size: 18) ??
            UIFont.boldSystemFont(ofSize: 18) ]
    }
}
