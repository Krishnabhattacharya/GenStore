//
//  add_address_view.swift
//  GenStore
//
//  Created by Krishna Bhattacharya on 05/01/26.
//
import SwiftUI
import GoogleMaps
import CoreLocation

struct AddressScreen: View {
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var vm: CartViewModel
    @EnvironmentObject var router: Router

    @State private var lat = 28.6139
    @State private var lng = 77.2090
    @State private var address = ""
    @State private var flatNumber = ""
    @State private var landmark = ""
    @State private var pincode = ""
    @State private var city = ""
    @State private var state = ""
    @State private var addressType = "Home"
    @State private var showSheet = false
    @State private var isLoadingAddress = false
    
    let addressTypes = ["Home", "Work", "Other"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GoogleMapView(latitude: $lat, longitude: $lng)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Delivery Location")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if isLoadingAddress {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Text(address.isEmpty ? "Select location on map" : address)
                                    .font(.body)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    HStack(spacing: 12) {
                        Button(action: getCurrentLocation) {
                            HStack {
                                Image(systemName: "location.circle.fill")
                                Text("Use Current")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        Button(action: { showSheet = true }) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text("Confirm Location")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                        .disabled(address.isEmpty)
                        .opacity(address.isEmpty ? 0.6 : 1)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .sheet(isPresented: $showSheet) {
            AddressFormSheet(
                address: $address,
                flatNumber: $flatNumber,
                landmark: $landmark,
                pincode: $pincode,
                city: $city,
                state: $state,
                addressType: $addressType,
                addressTypes: addressTypes,
                lat: lat,
                lng: lng,
            
            ).environmentObject(vm).environmentObject(router)
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: lat) { _ in fetchAddress() }
        .onChange(of: lng) { _ in fetchAddress() }
    }
    
    private func getCurrentLocation() {
        locationManager.requestLocation { location in
            if let location = location {
                lat = location.coordinate.latitude
                lng = location.coordinate.longitude
            }
        }
    }
    
    private func fetchAddress() {
        isLoadingAddress = true
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            isLoadingAddress = false
            
            guard let placemark = placemarks?.first, error == nil else {
                address = "Unable to fetch address"
                return
            }
            
            var addressComponents: [String] = []
            
            if let name = placemark.name { addressComponents.append(name) }
            if let locality = placemark.locality { addressComponents.append(locality) }
            if let administrativeArea = placemark.administrativeArea { addressComponents.append(administrativeArea) }
            if let postalCode = placemark.postalCode { addressComponents.append(postalCode) }
            
            address = addressComponents.joined(separator: ", ")
            city = placemark.locality ?? ""
            state = placemark.administrativeArea ?? ""
            pincode = placemark.postalCode ?? ""
        }
    }
}

struct AddressFormSheet: View {

    @Environment(\.dismiss) var dismiss
    @Binding var address: String
    @Binding var flatNumber: String
    @Binding var landmark: String
    @Binding var pincode: String
    @Binding var city: String
    @Binding var state: String
    @Binding var addressType: String
    let addressTypes: [String]
    let lat: Double
    let lng: Double
    @EnvironmentObject var vm: CartViewModel
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details")) {
                    HStack {
                        Text("Latitude:")
                        Spacer()
                        Text(String(format: "%.6f", lat))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Longitude:")
                        Spacer()
                        Text(String(format: "%.6f", lng))
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Address")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(address)
                    }
                }
                
                Section(header: Text("Complete Address")) {
                    TextField("Flat / House No. / Building", text: $flatNumber)
                    TextField("Landmark (Optional)", text: $landmark)
                    
                    HStack {
                        TextField("Pincode", text: $pincode)
                            .keyboardType(.numberPad)
                        
                        TextField("City", text: $city)
                    }
                    
                    TextField("State", text: $state)
                }
                
                Section(header: Text("Save Address As")) {
                    Picker("Address Type", selection: $addressType) {
                        ForEach(addressTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(action: saveAddress) {
                        HStack {
                            Spacer()
                            Text("Save Address")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Complete Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !flatNumber.isEmpty && !pincode.isEmpty && !city.isEmpty && !state.isEmpty
    }
    
    private func saveAddress() {
        // Save address logic here
        print("Saving address:")
        print("Flat: \(flatNumber)")
        print("Landmark: \(landmark)")
        print("Address: \(address)")
        print("Pincode: \(pincode)")
        print("City: \(city)")
        print("State: \(state)")
        print("Type: \(addressType)")
        print("Coordinates: \(lat), \(lng)")
        Task {
           await vm.placeOrdersFromCart()
            router.pop()
        }
        dismiss()
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.first)
        completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        completion?(nil)
        completion = nil
    }
}
