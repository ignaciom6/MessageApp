//
//  RemoteStore.swift
//  WhaleTalk
//
//  Created by Ignacio on 12/7/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation

protocol RemoteStore
{
    func signUp(phoneNumber phoneNumber:String,email:String, password:String, success:()->(),error:(errorMessage:String)->())
    
    func startSyncing()
}
