//
//  ContactsViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 18/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, ContextViewController {

    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "All Contacts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: #selector(ContactsViewController.newContact))
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        fillWithView(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newContact()
    {
        
    }

}
