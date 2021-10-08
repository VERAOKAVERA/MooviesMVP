// MoovieDescription.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

struct Description: Decodable {
    var posterPath: String?
    let title: String
    let overview: String
}

@objc(CoreDescription)
class CoreDescription: NSManagedObject {
    @NSManaged var posterPath: String?
    @NSManaged var title: String
    @NSManaged var overview: String
    @NSManaged var id: Int
}
