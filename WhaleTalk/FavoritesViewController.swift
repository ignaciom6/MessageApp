//
//  FavoritesViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 11/7/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class FavoritesViewController: UIViewController, TableViewFetchedResultsDisplayer, ContextViewController
{
    var context:NSManagedObjectContext?
    
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "FavoriteCell"
    private let store = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(FavoriteCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        fillWithView(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        if let context = context{
            let request = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "favorite = true")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true),NSSortDescriptor(key: "firstName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            do
            {
                try fetchedResultsController?.performFetch()
            }
            catch
            {
                print("There was a problem fetching.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath)
    {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        guard let cell = cell as? FavoriteCell else {return}
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.status ?? "***no status***"
        cell.phoneTypeLabel.text = contact.phoneNumbers?.filter({
            number in
            guard let number = number as? PhoneNumber else {return false}
            return number.registered}).first?.kind
        
//        cell.phoneTypeLabel.text = contact.phoneNumbers?.allObjects.first?.kind
        
        cell.accessoryType = .DetailButton
    }

}

extension FavoritesViewController: UITableViewDataSource
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
}

extension FavoritesViewController: UITableViewDelegate
{
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
    {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        guard let id = contact.contactId else {return}
        let cncontact: CNContact
        do
        {
            cncontact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        }
        catch
        {
            return
        }
        
        let vc = CNContactViewController(forContact:cncontact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
