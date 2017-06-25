//
//  NetworkClient.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//Singleton class for managing network call
class NetworkClient: NSObject {
    
    internal let baseURL: URL
    
    // MARK: - Class Constructors
    public static let shared: NetworkClient = {
        let file = Bundle.main.url(forResource: "Info", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: file!)
        let urlString = dictionary?["service_url"] as! String
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()
    
    // MARK: - Private init
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    //MARK: - Get Searched Place
    public func getSearchPlace(searchString: String,  onCompletion: @escaping (_ result: Place) -> Void) {
        Alamofire.request( "\(baseURL)json?address=\(searchString)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if let resData = swiftyJsonVar["results"].arrayObject {
                    let arrData = resData as! [[String:AnyObject]]
                    let address = arrData[0]["formatted_address"] as! String
                    let placeid = arrData[0]["place_id"] as! String
                    print(address )
                    let geometry = (arrData[0]["geometry"] as! [String:AnyObject])["location"] as! [String:Double]
                    let lat = geometry["lat"]! as Double
                    let lng = geometry["lng"]! as Double
                    let place = Place(name: searchString, placeid: placeid, type: address, latitude: lat, longitude: lng)
                    onCompletion(place)
                }
            }
        }
    }
    
}


