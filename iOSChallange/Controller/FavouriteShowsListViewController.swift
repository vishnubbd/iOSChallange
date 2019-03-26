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
          tableView.register(UINib(nibName: "ShowDetailTableViewCell", bundle: nil), forCellReuseIdentifier: GEN_STRINGS.CELL_LABEL)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = self.hexStringToUIColor(hex: "5A35F5")
        favoriteList = ShowListObject.sharedManager.getShowFavouriteList()
        self.tableView.reloadData()
    }
}
//MARK: - Methods for Table view
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GEN_STRINGS.CELL_LABEL, for: indexPath) as! ShowDetailTableViewCell
        
        let selectedshowDetail = self.favoriteList[indexPath.row]
        cell.showNameLabel?.text = selectedshowDetail.name
        // Check Image caching, If image has not cached. Add code for chacing the same image. Object name is using for cachching key
        cell.showImageView?.image = UIImage(named:GEN_STRINGS.DEFAULT_IMG)
        if let cachedImage = imageCache.object(forKey: NSString(string: (selectedshowDetail.name ?? ""))) {
            cell.imageView?.image = cachedImage
        }
            // Else code will not executed beacuse image already cached in Show detail screen
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
                                cell.showImageView?.image = image
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
//MARK: - Methods for Table view cell editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
/****************************************************************/
//   Row editing- only Delete option in favorite list
/***************************************************************/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedshowDetail = self.favoriteList[indexPath.row]
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            DataOperationsFromLocalDB.shared.deleteFavouriteItem(favoriteShowId: selectedshowDetail.id!)
            favoriteList = ShowListObject.sharedManager.getShowFavouriteList()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
/****************************************************************/
//  Router call: Controller for segue
/***************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GEN_STRINGS.SHOW_FAV_SEGUE
        {
            if let destinationVC = segue.destination as? ShowDetailsViewController {
                destinationVC.showDetails = self.selectedshowDetail
            }
        }
    }
    
    
}

