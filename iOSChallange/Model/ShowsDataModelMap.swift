//
//  ShowsDataModelMap.swift
//  iOSChallange
//
//  Created by VishnuKant Aggarwal - CONTRACT on 3/23/19.
//  Copyright © 2019 VishnuKant Aggarwal. All rights reserved.
//

import Foundation

/****************************************************************/
//   Structure contains all the parameter for Json Response but all the parameters are not using in application. Uncommented variable are only using in application.
/***************************************************************/
//struct Genres: Codable {
//    var id: Int?
//    var url: String?
//}
//struct Schedule: Codable {
//    var time: String?
//    var days: [String]
//}
struct Externals: Codable {
    var tvrage: Int?
    var thetvdb: Int?
    var imdb: String?
}
struct Image: Codable {
    var medium: String?
    var original: String?
}
//struct Link: Codable {
//    var previousepisode: Linkself
//    var `self`: Linkself
//}
//struct Linkself: Codable {
//    var href: String?
//}

//struct Rating: Codable {
//    var average: Double?
//}

//struct Country: Codable {
//    var name: String?
//    var code: String?
//     var timezone: String?
//}
struct MapShowListInfo: Codable {
    var id: Int?
//    var url: String?
    var name: String?
//    var type: String?
//    var language: String?
//    var genres: [String]
//    var status: String?
//    var runtime: Int?
//    var premiered: String?
//    var officialSite: String?
//    var schedule: Schedule
//    var rating:  Rating
//    var weight: Int?
//    var network: Network
//    var webChannel: String?
    var externals: Externals
    var image: Image
    var summary: String?
//    var updated: Int?
//    var _links: Link
    

}
