//
//  Event+CoreDataClass.swift
//  MyProjectEvent
//
//  Created by Student on 2018-04-03.
//  Copyright © 2018 Student. All rights reserved.
//
//

import Foundation
import CoreData


public class Event: NSManagedObject {
    
    var hasPhoto: Bool {
        return imageId != nil
    }

//    var photoURL: URL {
//        assert(imageId != nil, "No image ID set")
//        let filename = "Photo-\(imageId.intValue).jpg"
//        return applicationDocumentsDirectory.appendingPathComponent(filename)
//    }
//
//    var image: UIImage? {
//        return UIImage(contentsOfFile: photoURL.path)
//    }
//
    class func nextImageId() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "imageID") + 1
        userDefaults.set(currentID, forKey: "ImageID")
        userDefaults.synchronize()
        return currentID
    }
}
