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
    @State var weekInterval = Date(timeInterval: -604800, since: Date())
    @State var monthInterval = Date(timeInterval: -604800 * 4, since: Date())
    
    var body: some View {
        NavigationView {
            VStack {
            ScrollView {
                VStack(spacing: 7) {
                    Text(isFounded ? "Looking for owner" : "Looking for pet").font(.headline).foregroundColor(.gray)
                .foregroundColor(Color("listCl")).frame(width: UIScreen.main.bounds.width - 10, alignment: .center)
                    Text("This week").font(.headline)
                        .foregroundColor(.gray).frame(width: UIScreen.main.bounds.width - 10, alignment: .leading)
                    ForEach(viewmodel.places.sorted{ $0.publishTime! > $1.publishTime!}.filter{ $0.publishTime! > weekInterval }.filter{ $0.isFounded == self.isFounded }) { place in
                        NavigationLink(destination: ListItemView(item: place, userLocation: $userLocation)) {
                            ListItem(item: place)
                        }
                    }
                    Divider()
                    Text("This month").font(.headline)
                        .foregroundColor(.gray).frame(width: UIScreen.main.bounds.width - 10, alignment: .leading)
                    ForEach(viewmodel.places.sorted{ $0.publishTime! > $1.publishTime!}.filter{ $0.publishTime! > monthInterval && $0.publishTime! < weekInterval }.filter{ $0.isFounded == self.isFounded } ) { place in
                        NavigationLink(destination: ListItemView(item: place, userLocation: $userLocation)) {
                            ListItem(item: place)
                        }
                    }
                    Divider()
                    Text("Earlier").font(.headline)
                        .foregroundColor(.gray).frame(width: UIScreen.main.bounds.width - 10, alignment: .leading)
                    ForEach(viewmodel.places.sorted{ $0.publishTime! > $1.publishTime!}.filter{ $0.publishTime! < monthInterval }.filter{ $0.isFounded == self.isFounded } ) { place in
                        NavigationLink(destination: ListItemView(item: place, userLocation: $userLocation)) {
                            ListItem(item: place)
                        }
                    }
                }
            }
            }.sheet(isPresented: $showAboutUs, content: {
                AboutView(showAboutUs: $showAboutUs)
            }).toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("Recent").font(.largeTitle).fontWeight(.bold).padding([.leading, .bottom]).padding(.top, 10)
                }
            }.navigationBarItems(trailing:
                HStack {
                Button(action: {
                isFounded.toggle()
            }) {
                    Text(isFounded ? "🙋‍♂️" : "🐶").font(.system(size: 30))
                }
                    Button("About us") {
                        showAboutUs = true
                    }
                })
        }
    }
}


struct ListItem: View {
    @State var item: Place

    var body: some View {
        HStack {
            Text(item.animalType!).frame(width: 60, height: 60).font(.system(size: 49, weight: .bold)).padding(.leading, 15)
            Divider()
            VStack {
                
                    Text("\(item.isFounded ? "🙋‍♂️ " : "🐶 ")\(item.title)").font(.custom("san francisco", size: 22, relativeTo: .title))
                    .foregroundColor(Color("listCl"))
                        .frame(width: UIScreen.main.bounds.width / 2, height: 10, alignment: .leading)
                
                Text("\(item.formattingDate(date: item.publishTime, withoutTime: false)!)").font(.custom("san francisco", size: 18, relativeTo: .title)).frame(width: UIScreen.main.bounds.width / 2, height: 10, alignment: .leading).foregroundColor(Color.gray).padding(.top, 15)
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


