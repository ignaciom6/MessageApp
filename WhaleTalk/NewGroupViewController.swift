//
//  NewGroupViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 4/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController
{
    var context: NSManagedObjectContext?
    var chatCreationDelegate: ChatCreationDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "New Group"
    }

}
