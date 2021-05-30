//
//  AboutView.swift
//  firstDemo
//
//  Created by Никита Дубовик on 29.05.2021.
//

import SwiftUI

struct AboutView: View {
    @Binding var showAboutUs: Bool
    var body: some View {
        NavigationView {
            VStack {
                Text("Nikita Dubovik personal team").font(.custom("kohinoor bangla", size: 25))
                Text("email: flashes.n.co@gmail.com").font(.custom("kohinoor bangla", size: 18))
                Spacer(minLength: UIScreen.main.bounds.height - 200)
            }.navigationBarItems(leading: Button("\(Image(systemName: "chevron.left")) Done") {
                showAboutUs.toggle()
            }
            ).frame(width: UIScreen.main.bounds.width - 20, height: 60, alignment: .center)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About us").font(.custom("san francisco", size: 25))
                }
            }
            
        }
    }
}


