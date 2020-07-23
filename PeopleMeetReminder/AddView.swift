//
//  AddView.swift
//  PeopleMeetReminder
//
//  Created by DeNNiO   G on 14.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import MapKit
import CoreData
import CoreLocation

struct ButtonsMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.vertical)
    }
}

struct AddView: View {
    @State private var newNameText = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var companyName = ""
    @State private var description = ""
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State private var selectedImage: Image?
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var selectedImageId: UUID?
    @State private var source = 0
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var location = MKPointAnnotation()
    
    func loadSelectedImage() {
           guard let inputImage = inputImage else { return }
          selectedImage = Image(uiImage: inputImage)
    }
    
    let locationFetcher = LocationFetcher()
    
    func showLocation() {
        if let currentLocation = self.locationFetcher.lastKnownLocation {
            centerCoordinate = currentLocation
            location.coordinate = currentLocation
        } else {
            print("Your location is unknown")
        }
    }

    var body: some View {
        NavigationView {
        Form {
            
            Section(header: Text("Person name")) {
                TextField("Enter name", text: $newNameText)
            }
                        
            Section(header: Text("Company")){
                TextField("Enter company name", text: $companyName)
            }
            Section(header: Text("Contacts")){
                HStack{
                    TextField("Phone number", text: $phone)
                    TextField("E-mail", text: $email)
                }
            }
            Section(header: Text("Description")){
                TextField("Enter some info", text: $description)
            }
            
                Section(header: Text("Add Photo")) {
                    HStack {
                        Button(action: {
                            self.locationFetcher.start()
                            self.showLocation()
                            self.source = 0
                            self.showImagePicker = true
                        }) {
                            Image(systemName: "camera")
                            .modifier(ButtonsMod())
                        }
                            .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            self.locationFetcher.start()
                            self.source = 1
                            self.showImagePicker = true
                        }) {
                            Image(systemName: "photo")
                            .modifier(ButtonsMod())
                        }
                            .buttonStyle(BorderlessButtonStyle())
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.75))
                                .cornerRadius(20)
                            if selectedImage != nil {
                                selectedImage?
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(20)
                            } else {
                                Text("Select a picture")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                    }
                }
                                Section(header: Text("Location")) {
                                    ZStack {
                                        MapView(centerCoordinate: $centerCoordinate, annotation: location)
                                            .cornerRadius(20)
                                    VStack {
                                        Spacer()
                                            HStack {
                                                Spacer()
                                                    Button(action: {
                                                        self.showLocation()
                                                            }) {
                                                                Image(systemName: "globe")
                                                                .modifier(ButtonsMod())
                                                            }
                                                                .disabled(selectedImage == nil)
                                                                .buttonStyle(BorderlessButtonStyle())
                                            }
                                        }
                                    }
                                    .scaledToFit()
                                }
                                    Section(header: Text("Save")){
                                        Button(action: {
                                            let newPerson = NewPerson(context: self.moc)
                                            newPerson.name = self.newNameText
                                            newPerson.imageId = UUID()
                                            newPerson.longitude = self.location.coordinate.longitude
                                            newPerson.latitude = self.location.coordinate.latitude
                                            newPerson.companyName = self.companyName
                                            newPerson.descr = self.description
                                            newPerson.email = self.email
                                            newPerson.phoneNumber = self.phone
            
                                            if self.inputImage != nil {
                                                savePhoto(image: self.inputImage!, name: newPerson.imageId!.uuidString)
                                            }
                                            try? self.moc.save()
                                            self.presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Image(systemName: "tray.and.arrow.down")
                                                .modifier(ButtonsMod())
                                        }
                                                .buttonStyle(BorderlessButtonStyle())
                                    }
                                   
            
        }
        .modifier(TextMod1())
        .navigationBarTitle(Text("Add new person").font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded)))
        .sheet(isPresented: $showImagePicker, onDismiss: loadSelectedImage) { ImagePicker(image: self.$inputImage, typeOfSource: self.$source)
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
