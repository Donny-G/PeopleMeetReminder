//
//  DetailView.swift
//  PeopleMeetReminder
//
//  Created by DeNNiO   G on 14.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import MapKit


struct DetailView: View {
    var person: NewPerson
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    @State private var location = MKPointAnnotation()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    func deletePerson() {
        moc.delete(person)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func addLocations() {
        location.coordinate.latitude = person.latitude
        location.coordinate.longitude = person.longitude
        centerCoordinate = location.coordinate
    }
    
    var body: some View {
        Form {
            Section(header: Text("Company")){
                Text(person.companyName ?? "")
            }
            Section(header: Text("Contacts")){
                HStack{
                    Text(person.email ?? "")
                    Text(person.phoneNumber ?? "")
                }
            }
            Section(header: Text("Description")){
               Text(person.descr ?? "")
            }
                loadPicture(name: person.imageId!.uuidString)
                    .resizable()
                    .aspectRatio(0.9, contentMode: .fit)
                    .cornerRadius(20)
            Section(header: Text("Location")) {
                MapView(centerCoordinate: $centerCoordinate, annotation: location)
                    .scaledToFit()
                    .cornerRadius(20)
                    .onAppear(perform: addLocations)
            }
        }
            .modifier(TextMod1())
            .foregroundColor(.secondary)
            .navigationBarTitle(Text("\(person.name ?? "Unknown")").font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded)))
            .navigationBarItems(trailing: Button(action: {
                self.deletePerson()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                        .modifier(TextMod1())
                    }
                )
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(person: NewPerson())
    }
}
