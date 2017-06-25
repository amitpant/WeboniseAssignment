//
//  PlaceSearchViewController.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
import CoreData

class PlaceSearchViewController: UITableViewController {
    
    //MARK: - Properties
    var places = [Place]()
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let place = places[indexPath.row]
        cell.searchPlaceLabel.text = place.name
        cell.searchPlaceTypeLabel.text  = place.type
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place  = places[indexPath.row]
        let viewCtrl = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
        viewCtrl.place = place
        self.navigationController?.pushViewController(viewCtrl, animated: true)
    }
}

//Extension for handle coredata interaction
extension PlaceSearchViewController{
    // save place to persistent store
    func savePlace(place: Place) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Places", in: managedContext)!
        
        let placeManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        placeManagedObject.setValue(place.placeid, forKey: "placeid")
        placeManagedObject.setValue(place.name, forKey: "placename")
        placeManagedObject.setValue(place.type, forKey: "placetype")
        let lat = NSNumber(value: place.location.coordinate.latitude)
        let lng = NSNumber(value: place.location.coordinate.longitude)
        placeManagedObject.setValue( lat, forKey: "placelatitude")
        placeManagedObject.setValue(lng, forKey: "placelongitude")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    //fetching place from persistent store
    func getPlacesFromLocal(searchString:String)->[Place]? {
        var places = [Place]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        let sortDescriptor = NSSortDescriptor(key: "placename", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "placename CONTAINS[c] %@", searchString)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for record in records {
                print(record.value(forKey: "placename") ?? "no name")
                let placeid = record.value(forKey: "placeid") as! String
                let name = record.value(forKey: "placename") as! String
                let type = record.value(forKey: "placetype") as! String
                
                let longitude = record.value(forKey: "placelongitude") as! NSNumber
                let latitude = record.value(forKey: "placelatitude") as! NSNumber
                
                let place = Place(name: name, placeid: placeid, type: type, latitude: latitude.doubleValue, longitude: longitude.doubleValue )
                places.append(place)
            }
            
        } catch {
            print(error)
        }
        return places
    }
}

//Estension for Search bar
extension PlaceSearchViewController:UISearchBarDelegate{
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text{
            let workerQueue = DispatchQueue(label: "com.codefactory.worker", attributes: .concurrent)
            workerQueue.async {
                if (!self.places.contains(where: { (searchPlaced) -> Bool in searchPlaced.name == searchString }))
                {
                    NetworkClient.shared.getSearchPlace(searchString: searchString){
                        (place) in
                        self.places.append(place)
                        self.savePlace(place: place)
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: self.places.count - 1, section: 0)
                            self.tableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let workerQueue = DispatchQueue(label: "com.codefactory.worker1", attributes: .concurrent)
        workerQueue.async {
            if let places = self.getPlacesFromLocal(searchString: searchText) {
                if places.count>0 || self.places.count>0{
                    self.places = places
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}
