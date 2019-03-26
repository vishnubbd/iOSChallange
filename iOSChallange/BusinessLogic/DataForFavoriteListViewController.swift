//
//  DataForFavoriteListViewController.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/25/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit
import CoreData

class DataForFavoriteListViewController: UIViewController {
    static let shared = DataForFavoriteListViewController()
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    var addFavoriteItem:MapShowListInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
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
    func getFavouriteListFromDB()->[Int]{
        //         let context = self.appDelegate.persistentContainer.viewContext
        var favoriteListIds:[Int] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GEN_STRINGS.ENTITY_NAME_FAVLIST)
        //        request.predicate = NSPredicate(format: "id = %d", favoriteShowId)
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
    func checkItemInDB(favoriteShowId:Int)->Bool{
        //         let context = self.appDelegate.persistentContainer.viewContext
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
    
    func addRemovefavoriteItem(favoriteItem:MapShowListInfo? ){
        if( checkItemInDB(favoriteShowId:(favoriteItem?.id)!)){
            addDataIntoDb(addFavoriteItem: favoriteItem)
            
        }else{
            deleteFavouriteItem(favoriteShowId: favoriteItem!.id!)
        }
    }
    
}
