//
//  MapView.swift
//  PeopleMeetReminder
//
//  Created by DeNNiO   G on 15.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotation: MKPointAnnotation?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = annotation {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
            uiView.setCenter(annotation.coordinate, animated: true)
            let span = MKCoordinateSpan.init(latitudeDelta: 0.50, longitudeDelta: 0.50)
            let coordinate = CLLocationCoordinate2D.init(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude) // provide you lat and long
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            uiView.setRegion(region, animated: true)
        }
    }
    
    typealias UIViewType = MKMapView
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
            /*  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
                  parent.centerCoordinate = mapView.centerCoordinate
                }
            */
    }
    
    func makeCoordinator() -> Coordinator {
             Coordinator(self)
    }
    
}


