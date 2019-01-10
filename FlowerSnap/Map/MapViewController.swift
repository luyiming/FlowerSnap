//
//  MapViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2019/1/10.
//  Copyright © 2019 陆依鸣. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var sourceImage: UIImage?
    var predictIndex: [Int]?
    var predictProbs: [Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let campusCenter = CLLocation(latitude: 32.1188, longitude: 118.9579)
        
        let campusRegion = MKCoordinateRegion(center: campusCenter.coordinate, latitudinalMeters: 1500.0, longitudinalMeters: 1500.0)
        
        mapView.setRegion(campusRegion, animated: true)
//
//        mapView.addAnnotation(FlowerAnnotation(coordinate: campusCenter.coordinate, title: "My title", subtitle: "陆依鸣"))
        
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(FlowerAnnotation.self))

        fetchData()
    }
    
    func fetchData() {
        
        let task = URLSession.shared.dataTask(with: URL(string: "http://127.0.0.1:5000/query")!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
//            print(String.init(data: data, encoding: String.Encoding.utf8) ?? "")
//
            // create json object from data
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                print("json can not be serialized")
                return
            }
            
            if let json = json, let data = json["data"] as? [[String: Any]] {
                print("get \(data.count) data")
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for item in data {
                    let name = item["name"] as! String
                    let image_index = item["image_index"] as! String
                    let latitude = item["latitude"] as! Double
                    let longitude = item["longitude"] as! Double
                    let date = item["date"] as! String
                    let predictIndex = item["predictIndex"] as! [Int]
                    let predictProbs = item["predictProbs"] as! [Double]
                    
                    let anno = FlowerAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name, date: date, image_index: image_index, predictIndex: predictIndex, predictProbs: predictProbs)
                    
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(anno)
                    }
                }
            }
        }
        
        task.resume()
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? Artwork else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
    
        let reuseIdentifier = NSStringFromClass(FlowerAnnotation.self)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        annotationView.canShowCallout = true
        
        // Provide the left image icon for the annotation.
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        // Offset the flag annotation so that the flag pole rests on the map coordinate.
//        let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
//        annotationView.centerOffset = offset
        
        return annotationView
        
//
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "FlowerAnnotation")
//        annotationView.canShowCallout = true
//        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        guard let annotation = view.annotation as? FlowerAnnotation else { return }
        
        let url = URL(string: "http://127.0.0.1:5000/detail?image_index=\(annotation.image_index!)")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let imageData = Data.init(base64Encoded: data, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            
            self.sourceImage = UIImage.init(data: imageData!)
            self.predictProbs = annotation.predictProbs
            self.predictIndex = annotation.predictIndex
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowResultFromMap", sender: self)
            }
        }
        
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResultFromMap" {
            if let resultViewController = segue.destination as? ResultViewController {
                resultViewController.sourceImage = self.sourceImage
                resultViewController.predictIndex = self.predictIndex ?? [Int]()
                resultViewController.predictProbs = self.predictProbs ?? [Double]()
            }
        }
    }
}
