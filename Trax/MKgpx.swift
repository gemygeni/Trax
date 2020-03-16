//
//  MKgpx.swift
//  Trax
//
//  Created by AHMED GAMAL  on 3/10/20.
//  Copyright © 2020 AHMED GAMAL . All rights reserved.
//

import MapKit
class EditableWaypoint : GPX.Waypoint{
    override var coordinate: CLLocationCoordinate2D {
        get{
            return super.coordinate
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
}



extension GPX.Waypoint : MKAnnotation{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
     var title: String?{
        return name
    }
    var subtitle: String? {
        return info
    }
    var thumbnailURL : NSURL?{
        return getImageUrL(type : "thumbnail")
    }
    
  var imageURL : NSURL?{
        return getImageUrL(type : "large")
    }
    
    private func  getImageUrL(type : String) -> NSURL?{
        for link in links{
            if link.type == type {
                return link.url as NSURL?
            }
        }
        return nil
    }
}
