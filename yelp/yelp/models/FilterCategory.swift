//
//  FilterCategory.swift
//  yelp
//
//  Created by Maricel Quesada on 10/2/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

class FilterCategory {
    var label: String
    var name: String
    var options: Array<Filter>
    var type: FilterCategoryType
    var expanded: Bool
    
    init(label: String, name: String, options: Array<Filter>, type: FilterCategoryType, expanded: Bool! = false) {
        self.label = label
        self.name = name
        self.options = options
        self.type = type
        self.expanded = expanded
    }
    
}

enum FilterCategoryType {
    case Single
    case Multiple
}
