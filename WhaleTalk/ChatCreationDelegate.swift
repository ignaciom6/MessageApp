//
//  ChatCreationDelegate.swift
//  WhaleTalk
//
//  Created by Ignacio on 28/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate
{
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
}