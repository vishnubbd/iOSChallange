//
//  ShowListObject.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/25/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit

class ShowListObject: NSObject {
    static let sharedManager = ShowListObject()
    var showList:[MapShowListInfo] = []
    func getDataForShowList(completion: @escaping ( _ data: [MapShowListInfo]?) -> Void ){
        NetworkingService.shared.newList(){(data, error) in
            if let error = error {
                print(error)
                completion (nil)
            }else{
            self.showList = data!
            completion (data)
            }
        }
    }
    
    func myFilteredObject(showId:Int)->[MapShowListInfo]{
        let filteredArray = self.showList.filter(){$0.id == showId }
        return filteredArray
    }
    
    func getShowFavouriteList()->[MapShowListInfo]{
        var favouriteList:[MapShowListInfo] = []
        let favoriteShowListIds = DataForFavoriteListViewController.shared.getFavouriteListFromDB()
        for  id in favoriteShowListIds{
            favouriteList.append(myFilteredObject(showId:id).first!)
        }
        return favouriteList
    }
    
}
