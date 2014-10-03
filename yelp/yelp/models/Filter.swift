//
//  Filter.swift
//  yelp
//
//  Created by Maricel Quesada on 10/2/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

class Filter {
    
    var label: String
    var value: String
    var selected: Bool
    
    init(label: String, value: String, selected: Bool! = false) {
        self.label = label
        self.value = value
        self.selected = selected
    }
        
}
