//
//  AppDelegate.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
//import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
  //      GMSServices.provideAPIKey("AIzaSyCkQzV8sYW4J2gCAQNvOutrz6L4srOcDQI")
        GMSPlacesClient.provideAPIKey("AIzaSyCkQzV8sYW4J2gCAQNvOutrz6L4srOcDQI")
        return true
       
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeboniseAssignment")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo) ")
            }
        }
        return container
    }()
}

