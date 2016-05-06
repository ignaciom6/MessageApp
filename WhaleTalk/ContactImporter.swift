//
//  ContactImporter.swift
//  WhaleTalk
//
//  Created by Ignacio on 6/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import CoreData
import Contacts

class ContactImporter
{
    func fetch()
    {
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts, completionHandler: {
            granted, error in
            
            if granted
            {
                do
                {
                    let req = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey])
                    
                    try store.enumerateContactsWithFetchRequest(req, usingBlock: {
                        cnContact, stop in
                        print(cnContact)
                    })
                    
                }
                catch let error as NSError
                {
                    print(error)
                }
                catch
                {
                    print("Error with do-catch")
                }
            }
        })
    }
}
