//
//  ContentView.swift
//  PeopleMeetReminder
//
//  Created by DeNNiO   G on 14.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreData

struct TextMod1: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded))
    }
}

struct ContentView: View {
    
    @FetchRequest(entity: NewPerson.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \NewPerson.name, ascending: true)]) var persons: FetchedResults<NewPerson>
    @State private var newPersonViewAddView = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    func deletePerson(at offsets: IndexSet) {
        for offset in offsets {
            let person = persons[offset]
            moc.delete(person)
        }
        try? moc.save()
    }
    
    var body: some View {
        NavigationView {
          
            List {
                ForEach(persons, id: \.self) {
                    person in
                    NavigationLink(destination: DetailView(person: person)){
                        HStack(alignment: .center, spacing: 30) {
                            Text(person.name ?? "")
                                .modifier(TextMod1())
                            Text(person.companyName ?? "")
                                .modifier(TextMod1())
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        loadPicture(name: person.imageId!.uuidString)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80, alignment: .center)
                            .scaledToFit()
                    }
                }.onDelete(perform: deletePerson)
            }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle(Text("PeopleMeetNote").font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded)))
                .navigationBarItems(leading: EditButton().foregroundColor(.gray).modifier(TextMod1()), trailing: Button(action: {
                    self.newPersonViewAddView = true
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .modifier(TextMod1())
                })
                .sheet(isPresented: $newPersonViewAddView) { AddView().environment(\.managedObjectContext, self.moc)
            }
        }
            .accentColor(.gray)
            .modifier(TextMod1())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
