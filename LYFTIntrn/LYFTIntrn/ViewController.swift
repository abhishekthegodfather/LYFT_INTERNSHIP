//
//  ViewController.swift
//  LYFTIntrn
//
//  Created by Cubastion on 21/03/23.
//

import UIKit
import MapKit
import CoreLocation

// MARK: TASK 3 LYFT
class MapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
            locationManager.stopUpdatingLocation()
    }
        
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            mapView.setCenter(userLocation.coordinate, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted, .denied :
            let alert = UIAlertController(title: "Location Access Denied", message: "Please allow location access in settings to use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            default:
                break
        }
    }
}


// MARK: TASK 2 LYFT
class ViewController: UIViewController {
    
    let rideHistory = [("Driver: Joe, 12/29/2021", "$26.50"),
                       ("Driver: Sandra, 01/03/2022", "$13.10"),
                       ("Driver: Hank, 01/11/2022", "$16.20"),
                       ("Driver: Michelle, 01/19/2022", "$8.50")]
    
    @IBOutlet weak var tableView : UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.cellId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as! TableViewCell
        let arrayString = stringPreprocessingPart(rideHistory)
        var intArray = arrayString[indexPath.row]
        cell.nameLabel.text = intArray[0]
        cell.dateLabel.text = intArray[1]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let price = getPriceThing(rideHistory)
        let alert = UIAlertController(title: "Price", message: "The Price of that ride is \(price[indexPath.row])", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getPriceThing(_ intArray: Array<(String, String)>) -> [String] {
        let priceArray = intArray.map { (_, price) in
            return price
        }
        return priceArray
    }
    
    
    func stringPreprocessingPart(_ intArray: Array<(String, String)>) -> Array<Array<String>> {
        let formattedRideHistory = intArray.map { (driverInfo, _) in
            let driverInfoComponents = driverInfo.components(separatedBy: ", ")
            return [driverInfoComponents[0], driverInfoComponents[1]]
        }
        return formattedRideHistory
    }
}

