//
//  Event+CoreDataProperties.swift
//  MyProjectEvent
//
//  Created by Student on 2018-04-03.
//  Copyright © 2018 Student. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventName: String?
    @NSManaged public var eventLocation: String?
    @NSManaged public var imageId: NSNumber?
    @NSManaged public var eventDiscription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var category: String?

}
