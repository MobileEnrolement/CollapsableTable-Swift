//
//  CollapsableTableProtocols.swift
//  CollapsableTable
//
//  Created by Robert Nash on 22/09/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

import UIKit

public protocol CollapsableTableViewSectionHeaderProtocol {
    func open(animated: Bool);
    func close(animated: Bool);
    var sectionTitleLabel: UILabel! { get }
    var interactionDelegate: CollapsableTableViewSectionHeaderInteractionProtocol! { get set }
    var tag: Int { get set }
}

public protocol CollapsableTableViewSectionHeaderInteractionProtocol {
    func userTapped(view: CollapsableTableViewSectionHeaderProtocol)
}

public protocol CollapsableTableViewSectionModelProtocol {
    var title: String { get }
    var isVisible: Bool { get set }
    var items: [AnyObject] { get }
}
