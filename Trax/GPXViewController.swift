//
//  ViewController.swift
//  Trax
//
//  Created by AHMED GAMAL  on 3/9/20.
//  Copyright © 2020 AHMED GAMAL . All rights reserved.
//

import UIKit
import MapKit
class GPXViewController: UIViewController , MKMapViewDelegate{

    var gpxURL : NSURL?{
        didSet{
            removeWaypoints()
            if let url = gpxURL {
                GPX.parse(url as URL) { gpx in
                    if gpx != nil {
                    self.addWaypoints(waypoints: gpx!.waypoints)
                  }
                }
            }
        }
    }
    
    private func removeWaypoints() {
        mapView?.removeAnnotations(mapView.annotations)
    }
        private func addWaypoints(waypoints : [GPX.Waypoint]){
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
      override func viewDidLoad() {
          super.viewDidLoad()
        gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx")
      }
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.mapType = .hybrid
            mapView.delegate = self
        }
    }
    
    
    @IBAction func addWaypoint(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            waypoint.name = "new point"
            mapView.addAnnotation(waypoint)
        }
    }
    
    
    
    //annotation delegate methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view : MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationIdentifier)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationIdentifier)
            view.canShowCallout = true
        }
        else {
            view.annotation = annotation
        }
        
        view.isDraggable = annotation is EditableWaypoint
        
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
            if waypoint is EditableWaypoint{
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
      return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                if let button = view.leftCalloutAccessoryView as? UIButton,
                let  url = (view.annotation as? GPX.Waypoint)?.thumbnailURL,
                let data = NSData(contentsOf: url as URL),
                    let image = UIImage(data: data as Data){
                    button.setImage(image, for: .normal)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView{
        performSegue(withIdentifier: Constants.ShowIageSegue, sender: view)
        }
        else if control == view.rightCalloutAccessoryView{
            mapView.deselectAnnotation(view.annotation, animated: true)
            performSegue(withIdentifier: Constants.EditUserWaypoint, sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let destination = segue.destination
        let view = sender as? MKAnnotationView
        let waypoint = view?.annotation as? GPX.Waypoint
        if identifier == Constants.ShowIageSegue{
        if let IVC = destination.contents as? ImageViewController {
            IVC.ImageUrl = waypoint?.imageURL as URL?
            IVC.title = waypoint?.name
           }
        }
        else if identifier == "Edit Waypoint"{
            if let editableWaypoint = waypoint as? EditableWaypoint{
                if let editVC = (destination.contents ) as? EditWaypointViewController {
                    editVC.waypointToEdit = editableWaypoint
                }
            }
        }
    }
//    
    @IBAction func  waypointdidEdited(segue: UIStoryboardSegue){
        selctWaypoint(    waypoint: (((segue.source.contents) as? EditWaypointViewController)?.waypointToEdit) )
        
    }
    
    private func selctWaypoint(waypoint : GPX.Waypoint?){
           if waypoint != nil{
            mapView.selectAnnotation(waypoint!, animated: true)
           }
       }
    // MARK:- constants
    private struct Constants {
         static let  LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
         static let AnnotationIdentifier = "waypoint"
         static let ShowIageSegue = "Show Image"
         static let EditUserWaypoint = "Edit Waypoint"
    }
}

extension UIViewController{
    var contents : UIViewController {
        if  let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? navcon
        }
        else{
            return self
        }
    }
    
}
