//
//  TableView+Extension.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/28/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
/****************************************************************/
//   Image caching for table view cell
/***************************************************************/
extension UITableView {
    func cacheImage(imageURL: String, forCell cell: ShowDetailTableViewCell, atIndexPath indexPath: IndexPath) {
        let url = URL(string: imageURL)
        if let imageFromCache = imageCache.object(forKey: (imageURL as AnyObject) as! NSString) {
            cell.showImageView?.image = imageFromCache
        }
        else {
            URLSession.shared.dataTask(with: url!) {
                data, response, error in
                if data != nil {
                    DispatchQueue.main.async { [weak self] in
                        let imageToCache = UIImage(data: data!)
                        imageCache.setObject(imageToCache!, forKey: (imageURL as AnyObject) as! NSString)
          // Check whether the cell is visbible or not.  It’s important to check whether the cell is visible on screen before updating the image. Otherwise, the image will be reused on each cell while scrolling. The check is a performance saver and mandatory to implement. If the concerned cell is visible, then you just assign the image to cell image view and add it to the cache collection for later use.
                        if let updatedCell =  self?.cellForRow(at: indexPath) as? ShowDetailTableViewCell {
 updatedCell.showImageView.cacheImage(urlString: imageURL)
                        }
                    }
                }
                }.resume()
        }
    }
}
