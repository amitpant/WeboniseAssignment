//
//  PlaceDetailViewController.swift
//  WeboniseAssignment
//
//  Created by Amit Pant on 24/06/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class PlaceDetailViewController: UIViewController {
    
    //MARK: - Properites
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var  place:Place?
    var placePhotos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMapView()
        
        self.collectionView.delegate = self
    }
    
    //MARK: Private Methods
    private func loadMapView( ) {
        
        guard let place = self.place else {
            return
        }
        navigationItem.title = place.name
        self.mapView.mapType = .standard
        self.mapView.isRotateEnabled = false
        self.mapView.addAnnotations([self.place!])
        
        let regionRadius: CLLocationDistance = 35000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(place.location.coordinate, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        //loading place images
        self.loadPhotosForPlace(placeID: place.placeid)
    }
    
    //Fetching images from Google Api
    private func loadPhotosForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else {
                for photo in (photos?.results)!{
                    GMSPlacesClient.shared().loadPlacePhoto(photo, callback: {
                        (photo, error) -> Void in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        else {
                            DispatchQueue.main.async {
                                self.placePhotos.append(photo!)
                                let indexPath = IndexPath(item: self.placePhotos.count - 1, section: 0)
                                self.collectionView.insertItems(at: [indexPath])
                            }
                        }
                    })
                }
            }
        }
    }
    
}

// Extension for Collection View
extension PlaceDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.placePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.downloadButton.tag = indexPath.item
        cell.cellImageView.image = placePhotos[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// Extension for ImageCollectionViewCellDelegate for downloading images
extension PlaceDetailViewController: ImageCollectionViewCellDelegate{
    
    func downloadImage(photoIndex: Int) {
        let image = self.placePhotos[photoIndex]
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("\((place?.name)!)_\(photoIndex).png")
            try? data.write(to: filename)
            //alert message
            let alertViewCtrl = UIAlertController(title: "Message", message: "File downloaded successfully!! ", preferredStyle: .alert)
            
            let alert = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertViewCtrl.addAction(alert)
            
            self.present(alertViewCtrl, animated: true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}


