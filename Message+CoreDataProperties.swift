//
//  Message+CoreDataProperties.swift
//  WhaleTalk
//
//  Created by Ignacio on 23/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var incoming: NSNumber?
    @NSManaged var text: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var chat: Chat?

}
