
//
//  MapView.swift
//  designField
//
//  Created by Никита Дубовик on 15.05.2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @State var addingMode = false
    @State var showItemInfo = false
    @State var showForm = false
    
    // filter options from /FilterView.swift/, connecting /MainScreenView.swift/
    @Binding var includeFrozen: Bool
    @Binding var filterAnimal: String
    @Binding var filterGender: String
    @Binding var searchRange: Double
    @Binding var showAll: Bool
    @Binding var userLocation: CLLocationCoordinate2D?
    
    // item that will be passed in /PlaceInfoView.swift/ throught the sheet
    // when the user tapped on map pin
    @State var item = Place()
    
    // just Map stuff
    @Binding var centerCoordinate: MKCoordinateRegion
    @State private var trackingMode = MapUserTrackingMode.follow
    
    // i use it only to get user location
    @State var manager = CLLocationManager()
    
    
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $centerCoordinate, interactionModes: MapInteractionModes.all, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: filterAnimal.isEmpty ? (showAll ? viewModel.places : viewModel.places.filter{ distance(point1: CLLocation(latitude: $0.latitude , longitude: $0.longitude), point2: CLLocation(latitude: userLocation?.latitude ?? 0, longitude: userLocation?.longitude ?? 0)) < searchRange
            }) : (showAll ? viewModel.places.filter{ $0.animalType == filterAnimal } : (viewModel.places.filter{ distance(point1: CLLocation(latitude: $0.latitude , longitude: $0.longitude), point2: CLLocation(latitude: userLocation?.latitude ?? 1, longitude: userLocation?.longitude ?? 1)) < searchRange
            }).filter { $0.animalType == filterAnimal }
            )) { place in
                MapAnnotation<Button>(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                    Button(action: {
                        showItemInfo = true
                        self.item = place
                    }) {
                        Text(place.animalType!).shadow(radius: 7)
                            .frame(width: 60, height: 60).font(.system(size: 32))
                    }
                }
            }.sheet(isPresented: $showItemInfo) {
                PlaceInfoView(showItemInfo: $showItemInfo, item: $item, userLocation: $userLocation) }
            
            VStack {
                Spacer()
                if !addingMode {
                    VStack {
                        if userLocation == nil {
                            Button("Allow geolocation \(Image(systemName: "location"))") {
                                onFetchUserLocation { cooordinates in
                                    userLocation = cooordinates
                                    centerCoordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                                }
                            }.padding()
                        } else {
                            if showAll {
                                Text("World\(Image(systemName: "location"))").padding()
                            } else {
                                Text("\(searchRange.isZero ? "" :"\(String(format: "%.f", searchRange)) kilometres") \(Image(systemName: "location"))").padding()
                            }
                        }
                    }.background(Color.gray.opacity(0.4)).clipShape(Capsule()).foregroundColor(.white).padding(.bottom)
                }
            }.sheet(isPresented: $showForm) {
                FormView(showForm: $showForm, coordinate: $centerCoordinate, animals: viewModel.animals) { newPlace in
                    viewModel.add(newPlace)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if !addingMode {
                        Button(action: {
                            addingMode = true
                        }) {
                            Text("+").font(.system(size: 36, weight: .light, design: .default)).frame(width: 30, height: 30).foregroundColor(.white).padding().background(Circle().fill(Color.green)).clipShape(Circle())
                            
                        }
                        .padding()
                    } else {
                        HStack {
                            Button(action: {
                                addingMode = false
                            }) {
                                Image(systemName: "xmark").frame(width: 30, height: 30).foregroundColor(.white).padding().background(Circle().fill(Color.red)).clipShape(Circle())
                            }
                            Button(action: {
                                showForm = true
                                addingMode = false
                            }) {
                                Image(systemName: "checkmark").frame(width: 30, height: 30).foregroundColor(.white).padding().background(Circle().fill(Color.green)).clipShape(Circle())
                            }
                        }.frame(width: 105, height: 40).padding().background(Color.black.opacity(0.7)).clipShape(Capsule()).offset(x: -10, y: -10)
                    }
                }}
        
            if addingMode {
            Text("+").font(.system(size: 40, weight: .medium, design: .serif)).foregroundColor(Color.green)
            }
        }
    }
    }


    private func onFetchUserLocation(_ completion: (CLLocationCoordinate2D) -> Void) {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        let location = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 51, longitude: 0)
        completion(location)
        
        print("fetching user location")
    }
    private func distance(point1: CLLocation, point2: CLLocation) -> Double {
        // make result positive and convert into kilometres; divide by 1609 instead of 1000 for miles
    let distance = (point1.distance(from: point2) > 0 ? point1.distance(from: point2) : point1.distance(from: point2) * -1) / 1000
        return distance
    }

