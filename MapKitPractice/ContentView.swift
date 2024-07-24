//
//  ContentView.swift
//  MapKitPractice
//
//  Created by Bhagyaraju on 13/03/24.
//

import SwiftUI
import MapKit
struct ContentView: View {
    @State var addressList = [(address: String, latitude: Double, longitude: Double)]()
    @State var enteredAddress = ""
    @State var latitude: CLLocationDegrees = 0.0
    @State var longitude: CLLocationDegrees = 0.0

    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                TextField("Enter Address", text: $enteredAddress)
                    .onChange(of: enteredAddress) { _ in
                        searchWithAddress()
                    }
                    
                Button("Search") {
                   searchWithAddress()
                }
            }
            List {
                ForEach(addressList, id: \.address) {  addressInfo in
                    VStack(alignment: .leading) {
                        Text("Address: \(addressInfo.address)")
                        Text("Latitude: \(addressInfo.latitude), Longitude: \(addressInfo.longitude)")
                    }
                }
            }
        }
        .onAppear {
            // Example usage:
            latitude = 37.7749
            longitude = -122.4194
        }
        .padding()
    }
    
    func searchWithAddress() {
        addressList.removeAll()
        searchForAddress(enteredAddress) { mapItems, error in
            if let error = error {
                print("Error searching for address: \(error.localizedDescription)")
                return
            }
            
            guard let mapItems = mapItems else {
                print("No map items found for the address.")
                return
            }
            
            for mapItem in mapItems {
                if let address = mapItem.placemark.title {
                    addressList.append((address, mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude))
                }
            }
        }
    }

    func searchForAddress(_ address: String, completion: @escaping ([MKMapItem]?, Error?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        let indiaRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        request.region = indiaRegion
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            completion(response.mapItems, nil)
        }
    }
}


#Preview {
    ContentView()
}
