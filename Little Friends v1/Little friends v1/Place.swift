//
//  Location.swift
//  firstDemo
//
//  Created by Никита Дубовик on 01.05.2021.
//

import FirebaseFirestoreSwift
import SwiftUI
import MapKit


struct Place: Identifiable, Codable {    
    @DocumentID var id = ""
    var publishTime: Date?
    var title = ""
    var subtitle = ""
    var phoneNumber = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var animalType: String?
    var gender: String?
    var isFounded = false
    var imageID = UUID()
}

extension Place {
    func formattingDate(date: Date?, withoutTime: Bool) -> String? {
        guard date != nil else {
            return nil
        }
        let formatter = DateFormatter()
        if withoutTime {
            formatter.dateFormat = "EEEE, MMM d"
        } else {
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
        return formatter.string(from: date!)
    }
}

extension Place {
    func distance(to point: CLLocation) -> Double {
        // make result positive and convert into kilometres; divide by 1609 instead of 1000 for miles
        let myPoint = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let distance = (myPoint.distance(from: point) > 0 ? myPoint.distance(from: point) : myPoint.distance(from: point) * -1) / 1000
        return distance
    }
}

