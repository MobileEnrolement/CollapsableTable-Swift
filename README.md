[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/rob-nash/CollapsableTable-Swift/master/LICENSE.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![](http://i.imgur.com/jDq37Ip.gif?1)
![](http://i.imgur.com/77YQhPE.gif?1)

#Description
The creative design of your UI, remains yours. All I offer here, is a protocol.

## Requirements
XCode 7.0+, iOS 8.1+

## Installation
In XCode, select 'Add Files To Project', and select the following
* CollapsableTableProtocols.swift
* CollapsableTableScene.swift

## Usage
1. Build a UITableView, either in code or from interface builder.
2. Subclass UITableViewHeaderFooterView and conform to the CollapsableTableViewSectionHeaderProtocol Protocol. Create a nib for this subclass.
3. Subclass CollapsableTableViewController and do the following inside your subclass:
	* override 'collapsableTableView' and return your table view
	* override 'model' and return a pointer to an array of objects, which conform to CollapsableTableViewSectionModelProtocol Protocol.
	* override 'sectionHeaderNibName' and return the filename of the nib you created in step 2.

Try the Demo by running the 'Example' scheme in the 'Development' workspace.

## Known issues
If you have > 8,000-10,000 rows in any given table view section, the framerate drops to a noticable level.

## Contributions
Please use the 'Development' workspace.
