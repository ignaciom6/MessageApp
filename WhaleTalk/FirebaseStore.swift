//
//  FirebaseStore.swift
//  WhaleTalk
//
//  Created by Ignacio on 13/7/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore
{
    private let context:NSManagedObjectContext
    private let rootRef = Firebase(url:"https://whaletalk-e991a.firebaseio.com/")
    
    init(context:NSManagedObjectContext)
    {
        self.context = context
    }
    
    func hasAuth() -> Bool
    {
        return rootRef.authData != nil
    }
}

extension FirebaseStore: RemoteStore
{
    func startSyncing()
    {
        
    }
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
    {
        
    }
    
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: () -> (), error: (errorMessage: String) -> ())
    {
        
    }
}
