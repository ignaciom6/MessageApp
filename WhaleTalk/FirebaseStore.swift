//
//  FirebaseStore.swift
//  WhaleTalk
//
//  Created by Ignacio on 13/7/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreData

class FirebaseStore
{
    private let context:NSManagedObjectContext
//    private let rootRef = Firebase(url:"https://whaletalk-e991a.firebaseio.com/")
    
    private var currentPhoneNumber: String? {
        set(phoneNumber)
        {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
        }
        get
        {
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    init(context:NSManagedObjectContext)
    {
        self.context = context
    }
    
    func hasAuth() -> Bool
    {
        var authentication = false
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil
            {
                // User is signed in.
                authentication = true
            }
            else
            {
                // No user is signed in.
                authentication = false
            }
        }
        
        return authentication
//        return rootRef.authData != nil
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
    
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: () -> (), error errorCallback: (errorMessage: String) -> ())
    {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {
            
            user, error in
            
            if error != nil
            {
                errorCallback(errorMessage: error!.description)
            }
            else
            {
                let newUser = [
                    "phoneNumber": phoneNumber
                ]
                self.currentPhoneNumber = phoneNumber
                
                let reference = FIRDatabase.database().reference()
                reference.child("users").child(user!.uid).setValue(newUser)
                
                FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
                    
                    user, error in
                    
                    if error != nil
                    {
                        errorCallback(errorMessage: error!.description)
                    }
                    else
                    {
                        success()
                    }
                })
            }
        })
    }
}
