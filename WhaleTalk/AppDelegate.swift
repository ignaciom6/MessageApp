//
//  AppDelegate.swift
//  WhaleTalk
//
//  Created by Ignacio on 5/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var contactImporter: ContactImporter?
    
    private var contactsSyncer: Syncer?
    private var contactsUploadSyncer: Syncer?
    private var firebaseSyncer: Syncer?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        let contactsContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        contactsContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        let firebaseContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        firebaseContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        contactsSyncer = Syncer(mainContext: mainContext, backgroundContext: contactsContext)
        contactsUploadSyncer = Syncer(mainContext: contactsContext, backgroundContext: firebaseContext)
        firebaseSyncer = Syncer(mainContext: mainContext, backgroundContext: firebaseContext)
        contactImporter = ContactImporter(context: contactsContext)
        importContacts(contactsContext)
        
        contactImporter?.listenForChanges()
        
        let tabController = UITabBarController()
        
        let vcData:[(UIViewController, UIImage, String)] = [
            (FavoritesViewController(),UIImage(named: "favorites_icon")!, "Favorites"),
            (ContactsViewController(), UIImage(named: "contact_icon")!, "Contacts"),
            (AllChatsViewController(), UIImage(named: "chat_icon")!, "Chats")]
        
        let vcs = vcData.map {
            (vc:UIViewController, image:UIImage, title:String)->UINavigationController in
            if var vc = vc as? ContextViewController
            {
                vc.context = mainContext
            }
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = image
            nav.title = title
            return nav
        }
        
        tabController.viewControllers = vcs
        window?.rootViewController = SignUpViewController()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func importContacts(context:NSManagedObjectContext){
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("dataSeeded")
        guard !dataSeeded else {return}
        
        contactImporter?.fetch()
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "dataSeeded")
    }


}

