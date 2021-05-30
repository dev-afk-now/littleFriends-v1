//
//  firstDemoApp.swift
//  firstDemo
//
//  Created by Никита Дубовик on 01.05.2021.
//

import SwiftUI
import Firebase

@main
struct firstDemoApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainScreenView()
        }
    }
}
