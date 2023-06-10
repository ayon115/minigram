//
//  CreatePostController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 3/6/23.
//

import UIKit
import ActionKit
import CoreLocation
import MapKit

class CreatePostController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    var lastKnownLocation: CLLocationCoordinate2D?
    
    var imagePickerController = UIImagePickerController()
    
    let defualtLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(23.7649, 90.3899);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.centerMapToLocation(location: self.defualtLocation)
        
        let dhaka = Place(coordinate: CLLocationCoordinate2DMake(23.7739, 90.3989), title: "Dhaka")
        let narayanganj = Place(coordinate: CLLocationCoordinate2DMake(23.6200, 90.5000), title: "Narayanganj")
        let gazipur = Place(coordinate: CLLocationCoordinate2DMake(23.9889, 90.3750), title: "Gazipur")
        
        self.mapView.addAnnotations([dhaka, narayanganj, gazipur])
        
        
       // let camera = MKMapCamera(lookingAtCenter: bdLocation, fromDistance: CLLocationDistance(), pitch: 0.0, heading: 180.0)
       // self.mapView.setCamera(camera, animated: true)
    }
    
    func centerMapToLocation (location: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 30000, longitudinalMeters: 30000)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func setup () {
        self.contentTextView.text = ""
        self.contentButton.addControlEvent(.touchUpInside) {
            
            let controller = UIAlertController(title: "Pick Image", message: "Please choose an image", preferredStyle: .actionSheet)
            let cameraButton = UIAlertAction(title: "Use Camera", style: .default) { _ in
                print("camera button clicked")
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePickerController = UIImagePickerController()
                    self.imagePickerController.sourceType = .camera
                    self.imagePickerController.cameraCaptureMode = .video
                    self.imagePickerController.allowsEditing = true
                    self.imagePickerController.delegate = self
                    self.present(self.imagePickerController, animated: true)
                } else {
                    MinigramApp.showAlert(from: self, title: "Camera Not Available", message: "This device does not have a camera.")
                }
            }
            let galleryButton = UIAlertAction(title: "Select From Gallery", style: .default) { _ in
                print("gallery button clicked")
                self.imagePickerController = UIImagePickerController()
                self.imagePickerController.sourceType = .photoLibrary
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.delegate = self
                self.present(self.imagePickerController, animated: true)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                print("cancel button clicked")
            }
            controller.addAction(cameraButton)
            controller.addAction(galleryButton)
            controller.addAction(cancelButton)
            self.present(controller, animated: true)
        }
        
        self.submitButton.addControlEvent(.touchUpInside) {
            
        }
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        imagePickerController.takePicture()
    }
}

extension CreatePostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        
        print("didFinishPickingMediaWithInfo")
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.contentImage.image = image
        
        /*
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
         */

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension CreatePostController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .authorizedWhenInUse {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // print(locations)
    }
}

extension CreatePostController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("didUpdate userLocation")
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("didFailToLocateUserWithError")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let place = annotation as? Place else {
            return nil
        }
        
        print(place)
        
        var annotationView: MKAnnotationView?
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "place") as? MKMarkerAnnotationView {
            annotationView = view
            annotationView?.annotation = annotation
        } else {
            annotationView = MKMarkerAnnotationView(annotation: place, reuseIdentifier: "place")
        }
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let place = view.annotation as? Place
        MinigramApp.showAlert(from: self, title: "Callout Tapped", message: "You are at " + (place?.title ?? ""))
        
    }
}

class Place: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    
        super.init()
    }
    
}
