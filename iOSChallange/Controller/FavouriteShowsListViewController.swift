//
//  SecondViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/18/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

class FavouriteShowsListViewController: UIViewController, UITableViewDelegate {
    
    var favoriteList:[MapShowListInfo] = []
     let imageCache = NSCache<NSString, UIImage>()
     var selectedshowDetail:MapShowListInfo?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkingService.shared.newList();
        // Do any additional setup after loading the view, typically from a nib.
  
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favoriteList = ShowListObject.sharedManager.getShowFavouriteList()
        self.tableView.reloadData()
    }
}

extension FavouriteShowsListViewController: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.favoriteList.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            return GEN_STRINGS.FAV_LIST
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
            
            let selectedshowDetail = self.favoriteList[indexPath.row]
            cell.textLabel?.text = selectedshowDetail.name
            //        cell.detailTextLabel?.text = headline.text
            cell.imageView?.image = UIImage(named:GEN_STRINGS.DEFAULT_IMG)
            if let cachedImage = imageCache.object(forKey: NSString(string: (selectedshowDetail.name ?? ""))) {
                cell.imageView?.image = cachedImage
            }
            else
            {
                if selectedshowDetail.image.medium != ""
                {
                    DispatchQueue.global(qos: .background).async {
                        
                        
                        
                        let url = URL(string:(selectedshowDetail.image.medium)!)
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.imageCache.setObject(image, forKey: NSString(string: (selectedshowDetail.name)!))
                                    cell.imageView?.image = image
                                }
                            }
                        }
                    }
                }
            }
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.selectedshowDetail = self.favoriteList[indexPath.row]
            performSegue(withIdentifier: GEN_STRINGS.SHOW_FAV_SEGUE, sender: self)
        }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         let selectedshowDetail = self.favoriteList[indexPath.row]
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            DataForFavoriteListViewController.shared.deleteFavouriteItem(favoriteShowId: selectedshowDetail.id!)
            favoriteList = ShowListObject.sharedManager.getShowFavouriteList()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == GEN_STRINGS.SHOW_FAV_SEGUE
            {
                if let destinationVC = segue.destination as? ShowDetailsViewController {
                    destinationVC.showDetails = self.selectedshowDetail
                }
            }
        }
        
        
    }

