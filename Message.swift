//
//  Message.swift
//  WhaleTalk
//
//  Created by Ignacio on 20/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var isIncoming: Bool {
        return sender != nil
    }

}
