//
//  ShowDetailsViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/24/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit
import WebKit

class ShowDetailsViewController: UIViewController, WKNavigationDelegate{
    @IBOutlet weak var tvShowButton : UIButton!
    @IBOutlet weak var showSummary : UITextView!
    @IBOutlet weak var showImage : UIImageView!
    var showDetails:MapShowListInfo?
     var showDetailNew:[MapShowListInfo] = []
    var webView: WKWebView!
    let imageMedCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImage()
        self.addShowSummary()
        self.addNavigationRightButton()
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationItem.title = showDetails?.name
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = UIColor(red:  255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 100.0/100.0)

    }
    func addNavigationRightButton(){
        if( DataOperationsFromLocalDB.shared.checkItemInDB(favoriteShowId: showDetails!.id!)){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: GEN_STRINGS.FAVOURITE_BTN, style: .plain, target: self, action: #selector(addDeleteFavoriteTapped))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title:  GEN_STRINGS.DELETE_BTN, style: .plain, target: self, action: #selector(addDeleteFavoriteTapped))
        }
        
    }
/****************************************************************/
//  Add summary
/***************************************************************/
    func addShowSummary(){
        let htmlString = showDetails!.summary
        let htmlData = NSString(string: htmlString!).data(using: String.Encoding.unicode.rawValue)
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        
        showSummary.attributedText = attributedString
    }
/****************************************************************/
//  Enable or disable the the Show to WEB url based on imdb value
/***************************************************************/
    func enableDisableShowLink(){
        if(showDetails?.externals.imdb != nil){
            tvShowButton.isHidden = false
        }else{
            tvShowButton.isHidden = true
        }
    }
    
/****************************************************************/
//  Action on Navigation Right button
/***************************************************************/
    @objc func addDeleteFavoriteTapped(){
       DataOperationsFromLocalDB.shared.addRemovefavoriteItem(favoriteItem: showDetails!)
        addNavigationRightButton()
        
    }
//MARK: - Add image in view with Image caching 
    func addImage(){
        showImage.image = UIImage(named:GEN_STRINGS.DEFAULT_IMG)
        if let cachedImage = imageMedCache.object(forKey: NSString(string: ((showDetails?.name)! + "Org"))) {
            showImage.image = cachedImage
        }
        else
        {
            if showDetails?.image.original != ""
            {
                DispatchQueue.global(qos: .background).async {
                    
                    
                    
                    let url = URL(string:(self.showDetails?.image.original)!)
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.imageMedCache.setObject(image, forKey: NSString(string: ((self.showDetails?.name)! + "Org")))
                                self.showImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }
 //MARK: - Open the web url for TV Show
    @IBAction func openLiveShow(_ sender: Any) {
        
        guard let url = URL(string: GEN_STRINGS.LIVE_SHOWURL + (showDetails?.externals.imdb)!) else {
            return 
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
}
