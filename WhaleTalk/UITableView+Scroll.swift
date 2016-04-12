//
//  UITableView+Scroll.swift
//  WhaleTalk
//
//  Created by Ignacio on 12/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import UIKit

extension UITableView
{
    func scrollToBottom()
    {
        if self.numberOfRowsInSection(0) > 0
        {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0)-1, inSection:0), atScrollPosition: .Bottom, animated: true)
        }
    }
}
