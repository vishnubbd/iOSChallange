//
//  FirstViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/18/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

class ShowsListViewController: UIViewController, UITableViewDelegate {
    var showList:[MapShowListInfo] = []
    var selectedshowDetail:MapShowListInfo?
    
    let imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
           tableView.register(UINib(nibName: "ShowDetailTableViewCell", bundle: nil), forCellReuseIdentifier: GEN_STRINGS.CELL_LABEL)
        self.loadData()
     
    }
    
 //MARK: - Methods for Getting the Show ist data from API
    func loadData(){
        ShowListObject.sharedManager.getDataForShowList(){ (data)in
            if(data == nil){
                DispatchQueue.main.async { [weak self] in
                    self?.showAlertMessage()
                }
            }else{
                self.showList = data!
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
/****************************************************************/
//   Show Alert message if there is any problem in getting the data from Network.
/***************************************************************/
    func showAlertMessage(){
        self.presentAlertWithTitle(title: GEN_STRINGS.ALERT_NW_TITLE, message: GEN_STRINGS.ALERT_NW_MSG, options: GEN_STRINGS.ALERT_BTN_RETRY, GEN_STRINGS.ALERT_BTN_CANCEL) { (option) in
            switch(option) {
            case GEN_STRINGS.ALERT_BTN_RETRY:
                self.loadData()
                break
            case GEN_STRINGS.ALERT_BTN_CANCEL:
                print(GEN_STRINGS.ALERT_BTN_CANCEL)
            default:
                break
            }
        }
    }
}

//MARK: - Methods for Table view
extension ShowsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return GEN_STRINGS.SHOW_LIST
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GEN_STRINGS.CELL_LABEL, for: indexPath) as! ShowDetailTableViewCell
        
        let selectedshowDetail = self.showList[indexPath.row]
        cell.showNameLabel?.text = selectedshowDetail.name
        cell.showImageView?.image = UIImage(named:GEN_STRINGS.DEFAULT_IMG)
        
        // Check Image caching, If image has not cached. Add code for chacing the same image. Object name is using for cachching key
        if let cachedImage = imageCache.object(forKey: NSString(string: (selectedshowDetail.name ?? ""))) {
            cell.showImageView?.image = cachedImage
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
        self.selectedshowDetail = self.showList[indexPath.row]
        performSegue(withIdentifier: GEN_STRINGS.SHOW_DETAIL_SEGUE, sender: self)
    }
//MARK: - Methods for Table view cell editing, Deleting & Favourite
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
/****************************************************************/
//   Change tghe row editing based on the show item- Favorite or not
/***************************************************************/
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let selectedshowDetail = self.showList[indexPath.row]
        if(!( DataOperationsFromLocalDB.shared.checkItemInDB(favoriteShowId: selectedshowDetail.id!))){
            let delete = UITableViewRowAction(style: .destructive, title: GEN_STRINGS.DELETE_BTN) { (action, indexPath) in
                // delete item at indexPath
                DataOperationsFromLocalDB.shared.deleteFavouriteItem(favoriteShowId: selectedshowDetail.id!)
            }
            return [delete]
        }else{
            let share = UITableViewRowAction(style: .normal, title: GEN_STRINGS.FAVOURITE_BTN) { (action, indexPath) in
                // share item at indexPath
                DataOperationsFromLocalDB.shared.addDataIntoDb(addFavoriteItem: selectedshowDetail)
            }
            share.backgroundColor = UIColor.green
            return [share]
        }
        
    }
    
/****************************************************************/
    //  Router call: Controller for segue
/***************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GEN_STRINGS.SHOW_DETAIL_SEGUE
        {
            if let destinationVC = segue.destination as? ShowDetailsViewController {
                destinationVC.showDetails = self.selectedshowDetail
            }
        }
    }
    
    
}

