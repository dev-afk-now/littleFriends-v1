//
//  ListOfPlaces.swift
//  firstDemo
//
//  Created by Никита Дубовик on 09.05.2021.
//

import SwiftUI
import MapKit

struct PlacesList: View {
    @ObservedObject var viewmodel: MainViewModel
    @Binding var userLocation: CLLocationCoordinate2D?
    @State var isFounded = true
    @State var showAboutUs = false
    
    var body: some View {
        NavigationView {
            VStack {
            ScrollView {
                VStack(spacing: 7) {
                    Text(isFounded ? "Looking for owner" : "Looking for pet").font(.headline)
                .foregroundColor(.black).frame(width: UIScreen.main.bounds.width - 10, alignment: .center)
                    ForEach(viewmodel.places.sorted{ $0.publishTime! > $1.publishTime!}.filter{ $0.isFounded == self.isFounded } ) { place in
                        NavigationLink(destination: ListItemView(item: place, userLocation: $userLocation)) {
                            ListItem(item: place)
                        }
                    }
                }
            }
            }.sheet(isPresented: $showAboutUs, content: {
                AboutView(showAboutUs: $showAboutUs)
            }).offset(x: 0, y: -20).toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("Recent").font(.largeTitle).fontWeight(.bold).padding(.leading).padding(.top, 10)
                }
            }.navigationBarItems(trailing:
                HStack {
                Button(action: {
                isFounded.toggle()
            }) {
                Image(systemName: isFounded ? "person.fill.checkmark" : "person.fill.questionmark").resizable().frame(width: 30, height: 20)
                }
                    Button("About us") {
                        showAboutUs = true
                    }
                })
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ListItem: View {
    @State var item: Place

    var body: some View {
        HStack {
            Text(item.animalType!).frame(width: 60, height: 60).font(.system(size: 49, weight: .bold)).padding(.leading, 15)
            Divider()
            VStack {
                HStack {
                    Text(item.title).font(.custom("san francisco", size: 20, relativeTo: .title))
                    .foregroundColor(Color("listCl"))
                    Image(systemName: item.isFounded ? "person.fill.checkmark" : "person.fill.questionmark").resizable().frame(width: 20, height: 15).foregroundColor(.gray)
            }.frame(width: 250, height: 10, alignment: .leading)
                Text("\(item.formattingDate(date: item.publishTime, withoutTime: false)!)").font(.custom("san francisco", size: 18, relativeTo: .title)).frame(width: 250, height: 10, alignment: .leading).foregroundColor(Color.gray).padding(.top, 15)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable().frame(width: 10, height: 20)
                .padding(.trailing, 20)
                .foregroundColor(.gray)
            
        }.frame(width: UIScreen.main.bounds.width - 20, height: 80, alignment: .leading).background(Color.gray.opacity(0.2)).cornerRadius(15)
        
    }
}
//AppleSDGothicNeo-SemiBold
//AppleSDGothicNeo-thin


