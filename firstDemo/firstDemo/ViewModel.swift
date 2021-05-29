//
//  ViewModel.swift
//  firstDemo
//
//  Created by Никита Дубовик on 01.05.2021.
//

import Foundation
import Combine


final class MainViewModel: ObservableObject {
    @Published var repository = Repository()
    @Published var places: [Place] = []
    
    @Published var countryCodes: [CountryCode] = []
    
    // MARK: Animal types to FormView(throught the MapView)
    var animals = ["🦮","🐈","🦜","🦝","🦎","🐎","🐢","🐇","🐀"]
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        repository.$places.assign(to: \.places, on: self).store(in: &cancellables)
        parseCountryCodes{ codes in
            self.countryCodes = codes
        }
    }
    
    func parseCountryCodes(completion: @escaping ([CountryCode]) -> ()) {
       guard let url = URL(string: "https://gist.githubusercontent.com/Goles/3196253/raw/9ca4e7e62ea5ad935bb3580dc0a07d9df033b451/CountryCodes.json") else { return }
       
       URLSession.shared.dataTask(with: url) { (data, _, _) in
        guard let list = data else { return }

           DispatchQueue.main.async {
            do {
                self.countryCodes = try! JSONDecoder().decode([CountryCode].self, from: list) }
            completion(self.countryCodes)
            print(self.countryCodes.isEmpty ? "[]" : "loaded codes / ViewModel.swift")
           }
       }.resume()
    }
    func add(_ place: Place) {
        repository.add(place)
    }
    func update(_ place: Place) {
        repository.update(place)
    }
}
struct CountryCode: Codable {
    var name: String?
    var dial_code: String?
    var code: String?
    
}

