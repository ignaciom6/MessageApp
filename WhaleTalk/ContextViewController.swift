//
//  ContextViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 18/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController
{
    var context: NSManagedObjectContext? {get set}
}
