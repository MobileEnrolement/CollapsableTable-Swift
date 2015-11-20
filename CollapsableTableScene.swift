//
//  CollapsableTableScene.swift
//  CollapsableTable
//
//  Created by Robert Nash on 22/09/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

import UIKit

public class CollapsableTableViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let
                tableView = self.collapsableTableView(),
                nibName = self.sectionHeaderNibName(),
                reuseID = self.sectionHeaderReuseIdentifier()
        {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: reuseID)
        }
    }
    
    public func collapsableTableView() -> UITableView? {
        return nil
    }
    
    public func model() -> [CollapsableTableViewSectionModelProtocol]? {
        return nil
    }
    
    public func singleOpenSelectionOnly() -> Bool {
        return false
    }
    
    public func sectionHeaderNibName() -> String? {
        return nil
    }
    
    public func sectionHeaderReuseIdentifier() -> String? {
        return self.sectionHeaderNibName()?.stringByAppendingString("ID")
    }
}

extension CollapsableTableViewController: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.model() ?? []).count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menuSection = self.model()?[section]
        return (menuSection?.isVisible ?? false) ? menuSection!.items.count : 0
    }
  
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view: CollapsableTableViewSectionHeaderProtocol?
        
        if let reuseID = self.sectionHeaderReuseIdentifier() {
            view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseID) as? CollapsableTableViewSectionHeaderProtocol
        }
        
        view?.tag = section
        
        let menuSection = self.model()?[section]
        view?.sectionTitleLabel.text = (menuSection?.title ?? "")
        view?.interactionDelegate = self
        
        return view as? UIView
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension CollapsableTableViewController: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? CollapsableTableViewSectionHeaderProtocol {
            let menuSection = self.model()?[section]
            if (menuSection?.isVisible ?? false) {
                view.open(false)
            } else {
                view.close(false)
            }
        }
    }
}

extension CollapsableTableViewController: CollapsableTableViewSectionHeaderInteractionProtocol {
    
    public func userTapped(view: CollapsableTableViewSectionHeaderProtocol) {
        
        if let tableView = self.collapsableTableView() {
            
            let section = view.tag
            
            tableView.beginUpdates()
            
            var foundOpenUnchosenMenuSection = false
            
            let menu = self.model()
            
            if let menu = menu {
                
                var count = 0
                
                for var menuSection in menu {
                    
                    let chosenMenuSection = (section == count)
                    
                    let isVisible = menuSection.isVisible
                    
                    if isVisible && chosenMenuSection {
                        
                        menuSection.isVisible = false
                        
                        view.close(true)
                        
                        let indexPaths = self.indexPaths(section, menuSection: menuSection)
                        
                        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: (foundOpenUnchosenMenuSection) ? .Bottom : .Top)
                        
                    } else if !isVisible && chosenMenuSection {
                        
                        menuSection.isVisible = true
                        
                        view.open(true)
                        
                        let indexPaths = self.indexPaths(section, menuSection: menuSection)
                        
                        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: (foundOpenUnchosenMenuSection) ? .Bottom : .Top)
                        
                    } else if isVisible && !chosenMenuSection && self.singleOpenSelectionOnly() {
                        
                        foundOpenUnchosenMenuSection = true
                        
                        menuSection.isVisible = false
                        
                        let headerView = tableView.headerViewForSection(count)
                        
                        if let headerView = headerView as? CollapsableTableViewSectionHeaderProtocol {
                            headerView.close(true)
                        }
                        
                        let indexPaths = self.indexPaths(count, menuSection: menuSection)
                        
                        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: (view.tag > count) ? .Top : .Bottom)
                    }
                    
                    count++
                }
                
            }
            
            tableView.endUpdates()
            
        }
    }
    
    private func indexPaths(section: Int, menuSection: CollapsableTableViewSectionModelProtocol) -> [NSIndexPath] {
        var collector = [NSIndexPath]()
        
        var indexPath: NSIndexPath
        for var i = 0; i < menuSection.items.count; i++ {
            indexPath = NSIndexPath(forRow: i, inSection: section)
            collector.append(indexPath)
        }
        
        return collector
    }
}