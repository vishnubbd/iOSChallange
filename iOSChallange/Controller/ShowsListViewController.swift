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
      self.loadData()
    }

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
  
}
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let selectedshowDetail = self.showList[indexPath.row]
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
          self.selectedshowDetail = self.showList[indexPath.row]
        performSegue(withIdentifier: GEN_STRINGS.SHOW_DETAIL_SEGUE, sender: self)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
       let selectedshowDetail = self.showList[indexPath.row]
        if(!( DataForFavoriteListViewController.shared.checkItemInDB(favoriteShowId: selectedshowDetail.id!))){
        let delete = UITableViewRowAction(style: .destructive, title: GEN_STRINGS.DELETE_BTN) { (action, indexPath) in
            // delete item at indexPath
            DataForFavoriteListViewController.shared.deleteFavouriteItem(favoriteShowId: selectedshowDetail.id!)
        }
             return [delete]
        }else{
        let share = UITableViewRowAction(style: .normal, title: GEN_STRINGS.FAVOURITE_BTN) { (action, indexPath) in
            // share item at indexPath
           DataForFavoriteListViewController.shared.addDataIntoDb(addFavoriteItem: selectedshowDetail)
        }
             share.backgroundColor = UIColor.green
            return [share]
        }
    
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GEN_STRINGS.SHOW_DETAIL_SEGUE
        {
            if let destinationVC = segue.destination as? ShowDetailsViewController {
                destinationVC.showDetails = self.selectedshowDetail
            }
        }
    }

  
}

