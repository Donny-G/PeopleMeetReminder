//
//  ImageSaver.swift
//  PeopleMeetReminder
//
//  Created by DeNNiO   G on 15.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

func getDocumentsDirectory() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
}

func savePhoto(image: UIImage, name: String) {
    let url = getDocumentsDirectory().appendingPathComponent(name)
    if let jpegData = image.jpegData(compressionQuality: 0.8){
        try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
    } else {
        print("error")
        
    }
}

func loadPicture(name: String) -> Image {
    let url = getDocumentsDirectory().appendingPathComponent(name)
    if let loadedData = try? Data(contentsOf: url) {
        if let imageFromData = UIImage(data: loadedData) {
            return Image(uiImage: imageFromData)
        }
    }
    return Image(systemName: "person.circle.fill")
}

    

