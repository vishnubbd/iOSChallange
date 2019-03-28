//
//  ImageCaching.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/27/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit


let imageCacheOrg = NSCache<NSString, UIImage>()
extension UIImageView {

    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
//        image = nil
        
        if let imageFromCache = imageCacheOrg.object(forKey: (urlString as AnyObject) as! NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCacheOrg.setObject(imageToCache!, forKey: (urlString as AnyObject) as! NSString)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}

