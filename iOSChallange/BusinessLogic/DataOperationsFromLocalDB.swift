//
//  DataOperationsFromLocalDB.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/26/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class DataOperationsFromLocalDB: NSObject {
    static let shared = DataOperationsFromLocalDB()
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    var addFavoriteItem:MapShowListInfo?
/****************************************************************/
//   Class contains the Opertaion methods for local database
/***************************************************************/
//MARK: - Add data for favorite show in to local DB
    func addDataIntoDb(addFavoriteItem:MapShowListInfo?){
        if (checkItemInDB(favoriteShowId: (addFavoriteItem?.id)!)){
            let entity = NSEntityDescription.entity(forEntityName: GEN_STRINGS.ENTITY_NAME_FAVLIST, in: context)
            let newFavoriteItem = NSManagedObject(entity: entity!, insertInto: context)
            newFavoriteItem.setValue(addFavoriteItem?.id, forKey: "id")
            newFavoriteItem.setValue(addFavoriteItem?.name, forKey: "name")
            newFavoriteItem.setValue(addFavoriteItem?.summary, forKey: "summary")
            self.saveToPersistent(context: context)
        }
    }
    private func saveToPersistent(context:NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
//MARK: - Get data for favorite show from local DB
    func getFavouriteListFromDB()->[Int]{
        var favoriteListIds:[Int] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GEN_STRINGS.ENTITY_NAME_FAVLIST)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                favoriteListIds.append(data.value(forKey: "id") as! Int)
            }
            
        } catch {
            
            print("Failed")
        }
        return favoriteListIds
    }
//MARK: - Check a show item in DB, whether it exist or not
    func checkItemInDB(favoriteShowId:Int)->Bool{

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GEN_STRINGS.ENTITY_NAME_FAVLIST)
        request.predicate = NSPredicate(format: "id = %d", favoriteShowId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            //            for data in result as! [NSManagedObject] {
            //                print(data.value(forKey: "name") as! String)
            //            }
            if  result.count > 0{
                return false
            }
        } catch {
            
            print("Failed")
        }
        return true
    }
//MARK: - Delete a record from DB, If favorite item exist in DB
    func deleteFavouriteItem(favoriteShowId:Int){
        
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: GEN_STRINGS.ENTITY_NAME_FAVLIST)
        requestDel.returnsObjectsAsFaults = false
        let predicateDel = NSPredicate(format: "id = %d", favoriteShowId)
        requestDel.predicate = predicateDel
        
        do {
            let arrUsrObj = try context.fetch(requestDel)
            for usrObj in arrUsrObj as! [NSManagedObject] { // Fetching Object
                context.delete(usrObj) // Deleting Object
            }
        } catch {
            print("Failed")
        }
        saveToPersistent(context: context)
    }
  //***********************************************************/
   // Call for local class method for adding and removing the favourite item in to DB
    //*********************************************************/
    func addRemovefavoriteItem(favoriteItem:MapShowListInfo? ){
        if( checkItemInDB(favoriteShowId:(favoriteItem?.id)!)){
            addDataIntoDb(addFavoriteItem: favoriteItem)
            
        }else{
            deleteFavouriteItem(favoriteShowId: favoriteItem!.id!)
        }
    }
    
}
