//
//  Chat.swift
//  WhaleTalk
//
//  Created by Ignacio on 23/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import CoreData


class Chat: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var lastMessage:Message?
    {
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "chat = %@", self)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        do
        {
            guard let results = try self.managedObjectContext?.executeFetchRequest(request) as? [Message] else {return nil}
            return results.first
        }
        catch
        {
            print("Error for Request")
        }
        return nil
    }
    
    func add(participant contact: Contact)
    {
        mutableSetValueForKey("participants").addObject(contact)
    }
}
