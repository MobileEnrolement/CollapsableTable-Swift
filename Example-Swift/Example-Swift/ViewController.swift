//
//  ViewController.swift
//  Example-Swift
//
//  Created by Robert Nash on 22/09/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

import UIKit
import CollapsableTable

class ViewController: CollapsableTableViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let menu = ModelBuilder.buildMenu()
    
    override func model() -> [CollapsableTableViewSectionModelProtocol]? {
        return menu
    }

    override func sectionHeaderNibName() -> String? {
        return "MenuSectionHeaderView"
    }
    
    override func singleOpenSelectionOnly() -> Bool {
        return true
    }
    
    override func shouldCollapse(tableSection: Int) -> Bool {
        let menuSection = self.model()?[tableSection]
        return (menuSection?.items ?? []).count < 1000
    }
    
    override func collapsableTableView() -> UITableView? {
        return tableView
    }
}

extension ViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("Cell")!
    }
}
