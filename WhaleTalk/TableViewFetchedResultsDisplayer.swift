//
//  TableViewFetchedResultsDisplayer.swift
//  WhaleTalk
//
//  Created by Ignacio on 24/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewFetchedResultsDisplayer
{
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}