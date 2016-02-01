/**
*  CollapsableTable - Collapsable table view sections with custom section header views.
*
*  CollapsableTableScene.swift
*
*  For usage, see documentation of the classes/symbols listed in this file.
*
*  Copyright (c) 2016 Rob Nash. Licensed under the MIT license, as follows:
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
*  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*  copies of the Software, and to permit persons to whom the Software is
*  furnished to do so, subject to the following conditions:
*
*  The above copyright notice and this permission notice shall be included in all
*  copies or substantial portions of the Software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*  SOFTWARE.
*/

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
    
    /*!
    * @discussion Override this method to return a custom table view.
    * @return the table view. Is nil unless overriden.
    */
    public func collapsableTableView() -> UITableView? {
        return nil
    }

    /*!
    * @discussion Override this method to return a custom model for the table view.
    * @return the model for the table view. Is nil unless overriden.
    */
    public func model() -> [CollapsableTableViewSectionModelProtocol]? {
        return nil
    }
        
    /*!
    * @discussion Only one section is visible when the user taps to select a section. Deselecting an open section, closes all sections. By returning 'NO' for this value, then this rule is ignored.
    * @return a boolean indication for conforming to the single open selection rule. Is 'NO' by defualt.
    */
    public func singleOpenSelectionOnly() -> Bool {
        return false
    }

    /*!
    * @discussion Override this method to return the nib name of your UITableViewHeaderFooterView subclass.
    * @return the section header nib name. Is nil unless overriden.
    */
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
    
    public func userTappedView<T : UITableViewHeaderFooterView where T : CollapsableTableViewSectionHeaderProtocol>(headerView: T, atPoint location: CGPoint) {
        
        guard let tableView = self.collapsableTableView() else {
            return;
        }
            
        guard let tappedSection = sectionForUserSelectionInTableView(tableView, atTouchLocation: location, inView: headerView) else {
            return
        }
        
        guard let collection = self.model() else {
            return
        }
        
        var foundOpenUnchosenMenuSection = false
        
        var section = 0
        
        tableView.beginUpdates()
        
        for var model in collection {
            
            if tappedSection == section {
                
                model.isVisible = !model.isVisible
                
                toggleCollapseTableViewSectionAtSection(section,
                    withModel:model,
                    inTableView: tableView,
                    usingAnimation: (foundOpenUnchosenMenuSection) ? .Bottom : .Top,
                    forSectionWithHeaderFooterView: headerView
                )
                
            } else if model.isVisible && self.singleOpenSelectionOnly() {
                
                foundOpenUnchosenMenuSection = true
                
                model.isVisible = !model.isVisible
                
                guard let headerView = tableView.headerViewForSection(section) as? CollapsableTableViewSectionHeaderProtocol else {
                    return
                }
                
                toggleCollapseTableViewSectionAtSection(section,
                    withModel: model,
                    inTableView: tableView,
                    usingAnimation: (tappedSection > section) ? .Top : .Bottom,
                    forSectionWithHeaderFooterView: headerView
                )
                
            }
            
            section++
        }
        
        tableView.endUpdates()
        
    }
    
    func toggleCollapseTableViewSectionAtSection(section: Int, withModel model: CollapsableTableViewSectionModelProtocol, inTableView tableView:UITableView, usingAnimation animation:UITableViewRowAnimation, forSectionWithHeaderFooterView headerFooterView: CollapsableTableViewSectionHeaderProtocol) {
        
        let indexPaths = self.indexPaths(section, menuSection: model)
        
        if model.isVisible {
            headerFooterView.open(true)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        } else {
            headerFooterView.close(true)
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        }
    }
    
    func sectionForUserSelectionInTableView(tableView: UITableView, atTouchLocation location:CGPoint, inView view: UIView) -> Int? {
        
        let point = tableView.convertPoint(location, fromView: view)
        
        for var i = 0; i < tableView.numberOfSections; i++ {
            let rect = tableView.rectForHeaderInSection(i)
            if CGRectContainsPoint(rect, point) {
                return i
            }
        }
        
        return nil
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