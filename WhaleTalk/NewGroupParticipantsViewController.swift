//
//  NewGroupParticipantsViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 5/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData

class NewGroupParticipantsViewController: UIViewController
{
    var context: NSManagedObjectContext?
    var chat: Chat?
    var chatCreationDelegate: ChatCreationDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Add Participants"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
