//
//  PhoneNumber+CoreDataProperties.swift
//  WhaleTalk
//
//  Created by Ignacio on 15/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhoneNumber {

    @NSManaged var value: String?
    @NSManaged var contact: Contact?

}
