//
//  NetworkService.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/23/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import UIKit


class NetworkingService: NSObject, URLSessionDelegate {
    static let shared = NetworkingService()
/****************************************************************/
 //   Function for calling the show list API and Making connection with Network
/***************************************************************/
    func newList (completion: @escaping ( _ data: [MapShowListInfo]?,_ error: Error?) -> Void){
        guard let url = URL(string:GEN_STRINGS.SHOWURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? GEN_STRINGS.RES_ERROR)
                    return completion(nil, error)
                    
            }
            do{
             // Use JSON decoder for mapping the Json response for Object
                let decoder = JSONDecoder()
                let showParseList = try decoder.decode([MapShowListInfo].self, from:
                    dataResponse) //Decode JSON Response Data
                return completion(showParseList, nil)
            } catch let parsingError {
                print(GEN_STRINGS.ERROR, parsingError)
                return completion(nil, error)
            }
        }
        task.resume()
    }
       
}

