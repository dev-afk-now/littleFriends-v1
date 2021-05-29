//
//  FilterView.swift
//  firstDemo
//
//  Created by Никита Дубовик on 05.05.2021.
//

import Foundation
import SwiftUI
import MapKit

struct FilterView: View {
    @Binding var includeFrozen: Bool
    @Binding var animalType: String
    @Binding var userLocation: CLLocationCoordinate2D?
    @Binding var searchRange: Double
    @Binding var showAll: Bool
    @Binding var centerCoordinate: MKCoordinateRegion
    @Binding var filterGender: String
    
    @State var trailingText = ""
    var animals: [String]
    
    // i use it only for getting user location
    @State var manager = CLLocationManager()
    
    var body: some View {
            VStack (spacing: 15) {
                Button("\(userLocation != nil ? "To me" : "Enable location")\(Image(systemName: "location"))") {
                    onFetchUserLocation { cooordinates in
                        userLocation = cooordinates
                        centerCoordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
                    }
                }
                
                Text("\(searchRange.isZero ? "" :"\(String(format: "%.f", searchRange)) kilometres")").foregroundColor(.gray).opacity(0.8)
                if userLocation?.latitude ?? 0 > 1 || userLocation != nil {
                    VStack {
                        Slider(value: $searchRange, in: 1...100 ).disabled(showAll).frame(width: 360, height: 10)

                            Text(showAll ? "Enable distance filter" : "Switch to world search").font(.callout)
                        .foregroundColor(Color.gray.opacity(0.8)).padding(.vertical)
                        .onTapGesture { showAll.toggle(); searchRange = 0 }
                    }
                } else {
                    Text("Allow location access in privacy settings and try again").font(.caption).foregroundColor(.gray).frame(width: UIScreen.main.bounds.width - 10, height: 10, alignment: .center)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            animalType = ""
                        }) {
                            Text("\(Image(systemName: "xmark"))").foregroundColor((animalType.isEmpty ? Color.white: Color.gray.opacity(0.8))).font(.system(size: 38, weight: .medium)).frame(width: 70, height: 70).background(animalType.isEmpty ? Color.accentColor: Color.gray.opacity(0.2)).cornerRadius(15)
                        }
                        ForEach(animals, id: \.self) { animal in
                            
                            Button(action: {
                                animalType = animal
                            }) {
                                Text(animal).font(.system(size: 38, weight: .bold)).frame(width: 70, height: 70).background(animal == animalType ? Color.accentColor: Color.gray.opacity(0.2)).cornerRadius(15)
                            }
                        }
                    }
                }.padding(.horizontal)
                Spacer()
            }.padding(.top)
        
    }
    private func onFetchUserLocation(_ completion: (CLLocationCoordinate2D) -> Void) {
        manager.requestAlwaysAuthorization()
        let location = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 1, longitude: 1)
        completion(location)
        
        print("fetching user location")
    }
}
