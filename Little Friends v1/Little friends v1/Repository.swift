//
//  Repository.swift
//  firstDemo
//
//  Created by Никита Дубовик on 01.05.2021.
//

import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseFirestore
import Combine


final class Repository: ObservableObject {
    @Published var places = [Place]()
    private let path = "places"
    private var store = Firestore.firestore()
    var storage = Storage.storage()

    init() {
        get()
    }
    
     func get() {
        store.collection(path).addSnapshotListener { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.places = snapshot?.documents.compactMap { try? $0.data(as: Place.self)  } ?? []
        }
    }
    func add(_ place: Place) {
        do {
         _ = try store.collection(path).addDocument(from: place)
        } catch { fatalError("Enable to add document") }
    }
    
    func update(_ place: Place) {
        guard let documentID = place.id else { return }
        do {
            try store.collection(path).document(documentID).setData(from: place)
        } catch {
            fatalError("Enable to update document") }
    }
}

