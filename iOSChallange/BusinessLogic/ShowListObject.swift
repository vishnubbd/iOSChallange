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
/****************************************************************/
//   Getting the response fromn webservice for main show list
/***************************************************************/
    
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
 
/****************************************************************/
//   Getting a single Show object based on id from the array of show list getting from network list
/***************************************************************/
    func myFilteredObject(showId:Int)->[MapShowListInfo]{
        let filteredArray = self.showList.filter(){$0.id == showId }
        return filteredArray
    }
/****************************************************************/
//   Return Favorite list, Getting data from local DB
/***************************************************************/
    func getShowFavouriteList()->[MapShowListInfo]{
        var favouriteList:[MapShowListInfo] = []
        //Getting records (Show id) from local db for favorite list
        let favoriteShowListIds = DataOperationsFromLocalDB.shared.getFavouriteListFromDB()
        //Based on show id, getting Show object and add in to array.
        for  id in favoriteShowListIds{
            favouriteList.append(myFilteredObject(showId:id).first!)
        }
        return favouriteList
    }
    
}
