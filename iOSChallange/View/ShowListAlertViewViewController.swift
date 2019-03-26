//
//  ShowListAlertViewViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/25/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

class ShowListAlertViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
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
}
