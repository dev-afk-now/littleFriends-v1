
//
//  FormView.swift
//  firstDemo
//
//  Created by Никита Дубовик on 02.05.2021.
//
import SwiftUI
import MapKit
import FirebaseStorage


struct FormView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    @Binding var showForm: Bool
    @Binding var coordinate: MKCoordinateRegion
    
    @State var addNewTitle = ""
    @State var addNewNumber = ""
    @State var addNewSubtitle = ""
    @State var animalType = ""
    @State var gender = ""
    @State var image: UIImage?
    @State var founded = false

    @State var code = CountryCode()
    
    var animals: [String]

    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var showActionSheet = false
    @State var showImagePicker = false

    var didAddPlace: (_ newPlace: Place) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                        if image != nil {
                            Image(uiImage: image!).resizable().frame(width: 300, height: 200)
                        } else {
                            Image(systemName: "photo").resizable().frame(width: 300, height: 200 ).foregroundColor(Color.gray.opacity(0.1))
                        }
                        Button("Add an image") {
                            showActionSheet = true
                        }.actionSheet(isPresented: $showActionSheet) { onActionSheet }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(sourceType: sourceType, image: $image, showImagePicker: $showImagePicker)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(animals, id: \.self) { animal in

                                        Button(action: {
                                            animalType = animal
                                        }) {
                                            Text(animal).font(.system(size: 38, weight: .bold)).frame(width: 70, height: 70).background(animal == animalType ? Color.accentColor: Color.gray.opacity(0.1)).cornerRadius(15)
                                        }
                                }
                            }
                        }
                        RequestStatus(found: $founded).padding()
                        GenderTab(gender: $gender).padding(5)
                        Form {
                            Section(header: Text("Title")) {
                                VStack {
                                    TextField("Short representation", text: $addNewTitle)
                                }.frame(height: 40)
                            }
                           
                            Section(header: Text("Your phone number")) {
                                
                                    HStack {
                                        Text(code.dial_code ?? "+000").foregroundColor(Color("listCl"))
                                        Divider()
                                    TextField("00-00-00", text: $addNewNumber)
                                    }.frame(height: 40)
                                    Picker(selection: $code.dial_code, label: Text("Codes")) {
                                        Text("No code").tag(String?.none)
                                        ForEach(viewModel.countryCodes.filter{ $0.dial_code != nil || $0.name != nil }, id: \.dial_code) { code in
                                            Text("\(code.dial_code ?? "No code ")  \(code.name ?? "")").tag(code.dial_code)
                                    }
                                }.frame(height: 40)
                                
                            }
                            Section(header: Text("Description")) {
                                VStack {
                                    TextField("Description of animal", text: $addNewSubtitle)
                                }.frame(height: 40)
                            }
                        }.foregroundColor(Color("listCl")).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)

                }
                    .navigationBarTitle("Add new request")
                .navigationBarItems(leading: Button("\(Image(systemName: "chevron.left")) Cancel") { showForm = false }, trailing:                         onAddButton.disabled(addNewSubtitle.isEmpty || addNewNumber.isEmpty || gender.isEmpty || animalType.isEmpty))
            }.frame(maxHeight: .infinity)
            
            
        }
    }
    
    private func createNewPlace() {
        var formatedGender: String? {
            if gender == "♂︎" {
                return "male"
            }
            if gender == "♁" {
                return "female"
            } else {
                return nil
            }
        }

        let place = Place(publishTime: Date(),title: addNewTitle, subtitle: addNewSubtitle, phoneNumber: "\(code.dial_code ?? "")\(addNewNumber)", longitude: coordinate.center.longitude, latitude: coordinate.center.latitude, animalType: String(animalType.first!), gender: formatedGender!, isFounded: founded)
        if image != nil {
            uploadImage(uiImage: image!, place)
        }
        print("adding place")
        didAddPlace(place)
        
    }
    struct RequestStatus: View {
        @Binding var found: Bool
        var body: some View {
            HStack {
                Button(action: {
                    found.toggle()
                }) {
                    HStack {
                        HStack {
                            Text("\(found ? "🙋‍♂️" : "🐶")").font(.system(size: 30)).padding(.leading)
                            Spacer()
                            
                            Text("\(found ? "I found" : "I'm looking for")").font(.system(size: 28, weight: .medium, design: .default))
                            Spacer()
                            Image(systemName: "arrow.up.arrow.down").resizable().frame(width: 25, height: 25, alignment: .center).padding()
                        }.background(Color.accentColor).foregroundColor(.white)
                        
                    }.frame(width: UIScreen.main.bounds.width - 10, height: 50, alignment: .center).background(Color.gray.opacity(0.2)).cornerRadius(15)
                    
                }
            }
        }
    }
    struct GenderTab: View {
        @Binding var gender: String
        var body: some View {
            HStack {
                Button(action: {
                    withAnimation {  gender = "♁" }
                }) {
                    Text("♁").frame(width: (UIScreen.main.bounds.width - 10) / 2, height: 60).font(.system(size: 61, weight: .bold)).foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)).opacity(0.8)).background(gender == "♁" ? Color.accentColor : Color.gray.opacity(0.1)) }
                
                
                Button(action: {
                    withAnimation { gender = "♂︎"}
                }) {
                    Text("♂︎").frame(width: (UIScreen.main.bounds.width - 10) / 2, height: 60).font(.system(size: 61, weight: .bold)).foregroundColor(Color(#colorLiteral(red: 0.151424855, green: 0.270197928, blue: 1, alpha: 1)).opacity(0.8)).background(gender == "♂︎" ? Color.accentColor : Color.gray.opacity(0.1)) }
            }
            .frame(width: UIScreen.main.bounds.width - 10, height: 60, alignment: .leading).cornerRadius(15).padding(.top, 5).padding(.horizontal, 10)
        }
    }

    
    
    private func uploadImage(uiImage: UIImage, _ place: Place) {
        if let uiImage = uiImage.jpegData(compressionQuality: 1) {
            let storage = Storage.storage()
            storage.reference().child("\(place.imageID)").putData(uiImage)
            print("\(place.imageID): uuid of picture")
        } else {
            print("couldn't unwrap image to data")
        }
    }
    
    
    //MARK: Utilities
    var onActionSheet: ActionSheet {
        ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
            .default(Text("Camera")) {
                sourceType = .camera
                showImagePicker = true
            },
            .default(Text("Photo Library")) {
                sourceType = .photoLibrary
                showImagePicker = true
            },
            .cancel()
        ])
    }
    
    var onAddButton: Button<Text> {
        Button(action: {
            createNewPlace()
            showForm = false
        }) {
            Text("Add \(Image(systemName: "chevron.right"))").foregroundColor(.accentColor)
        }
    }
}
