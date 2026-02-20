//
//  map_view.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 14)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: uiView.camera.zoom)
        uiView.animate(to: camera)
        uiView.clear()
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = uiView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.latitude = coordinate.latitude
            parent.longitude = coordinate.longitude
        }
    }
}
