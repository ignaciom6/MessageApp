//
//  AllChatsViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 25/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController, TableViewFetchedResultsDisplayer {
    
    var context: NSManagedObjectContext?
    
    private var fetchedResultsController: NSFetchedResultsController?
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "MessageCell"
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage (named: "new_chat")),
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(AllChatsViewController.newChat))
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        tableView.delegate = self
        
        fillWithView(tableView)
        
        if let context = context
        {
            let request = NSFetchRequest(entityName: "Chat")
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            do
            {
                try fetchedResultsController?.performFetch()
            }
            catch
            {
                print("There was a problem fetching")
            }
        }
        
        fakeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func newChat()
    {
        let vc = NewChatViewController()
        vc.context = context
        
        let navVC = UINavigationController(rootViewController: vc)
        presentViewController(navVC, animated: true, completion: nil)
    }
    
    func fakeData()
    {
        guard let context = context else {return}
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as? Chat
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        let cell = cell as! ChatCell
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        
        cell.nameLabel.text = "Ignacio"
        cell.dateLabel.text = formatter.stringFromDate(NSDate())
        
        cell.messageLabel.text = "Hey!"
    }

}


extension AllChatsViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let currentSection = sections[section]
        
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
}

extension AllChatsViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100;
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
    }
}
