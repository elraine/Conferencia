//
//  DataObject.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import Foundation


class DataObject
{
    let event : Event
    private(set) var children : [Doc]
    var parent : Bool = false
    

    init(event : Event, children: [Doc], parent : Bool) {
        self.event = event
        self.children = children
        self.parent = parent
     
    }

    convenience init(event : Event) {
        self.init(event: event, children: [Doc](), parent : false)
    }

 
}