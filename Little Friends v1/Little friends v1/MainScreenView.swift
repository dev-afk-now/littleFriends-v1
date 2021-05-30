//
//  ContentView.swift
//  firstDemo
//
//  Created by Никита Дубовик on 01.05.2021.
//

import SwiftUI
import MapKit

struct MainScreenView: View {
    @ObservedObject var viewModel = MainViewModel()
    // MARK: - Bindings between filters and Map
    @State var includeFrozen = false
    @State var filterAnimal = ""
    @State var filterGender = ""
    @State var showAll = true
    @State var searchRange = Double()
    
    @State var centerCoordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.33, longitude: 37.22), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    @State var userLocation: CLLocationCoordinate2D?
    
 
    
    var body: some View {
        TabView {
            MapView(viewModel: MainViewModel(), includeFrozen: $includeFrozen, filterAnimal: $filterAnimal, filterGender: $filterGender, searchRange: $searchRange, showAll: $showAll, userLocation: $userLocation, centerCoordinate: $centerCoordinate)
                .tabItem {
                    Image(systemName: "map").resizable().frame(width: 10, height: 10, alignment: .center)
                    Text("Map")
                }
            PlacesList(viewmodel: viewModel, userLocation: $userLocation).tabItem{
                Image(systemName: "clock")
                Text("Recent")
            }
            FilterView(includeFrozen: $includeFrozen, animalType: $filterAnimal, userLocation: $userLocation, searchRange: $searchRange, showAll: $showAll, centerCoordinate: $centerCoordinate, filterGender: $filterGender, animals: viewModel.animals)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Map Filter")
                }
        }
    }
}

    


