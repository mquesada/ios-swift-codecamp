//
//  FilterManager.swift
//  yelp
//
//  Created by Maricel Quesada on 10/2/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

class FilterManager {    
    
    var filterCategoryList = [
        FilterCategory(label: "Deals", name: "deals_filter", options: [
                Filter(label: "Has Deals", value: "0", selected: true)
            ], type: FilterCategoryType.Single, expanded: true),
        FilterCategory(label: "Categories", name: "catgory_filter", options:
            [
                Filter(label: "American (New)", value: "newamerican", selected: true),
                Filter(label: "American (Traditional)", value: "tradamerican"),
                Filter(label: "Argentine", value: "argentine"),
                Filter(label: "Asian Fusion", value: "asianfusion"),
                Filter(label: "Brazilian", value: "brazilian"),
                Filter(label: "Breakfast & Brunch", value: "breakfast_brunch"),
                Filter(label: "Burgers", value: "burgers"),
                Filter(label: "Cafes", value: "cafes"),
                Filter(label: "Caribbean", value: "caribbean"),
                Filter(label: "Chinese", value: "chinese"),
                Filter(label: "Cuban", value: "cuban"),
                Filter(label: "French", value: "french"),
                Filter(label: "German", value: "german"),
                Filter(label: "Greek", value: "greek"),
                Filter(label: "Hawaiian", value: "hawaiian"),
                Filter(label: "Himalayan/Nepalese", value: "himalayan"),
                Filter(label: "Indian", value: "indpak"),
                Filter(label: "Irish", value: "irish"),
                Filter(label: "Italian", value: "italian"),
                Filter(label: "Japanese", value: "japanese"),
                Filter(label: "Latin American", value: "latin"),
                Filter(label: "Mediterranean", value: "mediterranean"),
                Filter(label: "Mexican", value: "mexican"),
                Filter(label: "Peruvian", value: "peruvian"),
                Filter(label: "Pizza", value: "pizza"),
                Filter(label: "Sandwiches", value: "sandwiches"),
                Filter(label: "Seafood", value: "seafood"),
                Filter(label: "Spanish", value: "spanish"),
                Filter(label: "Steakhouses", value: "steak"),
                Filter(label: "Sushi Bars", value: "sushi"),
                Filter(label: "Taiwanese", value: "taiwanese"),
                Filter(label: "Tapas Bars", value: "tapas"),
                Filter(label: "Thai", value: "thai"),
                Filter(label: "Vegan", value: "vegan"),
                Filter(label: "Vegetarian", value: "vegetarian"),
                Filter(label: "Vietnamese", value: "vietnamese")
            ], type: FilterCategoryType.Multiple),
        FilterCategory(label: "Distance", name: "radius_filter", options:
            [
                Filter(label: "5 miles", value: "5", selected: true),
                Filter(label: "10 miles", value: "10"),
                Filter(label: "15 miles", value: "15"),
                Filter(label: "25 miles", value: "25")
            ], type: FilterCategoryType.Single),
        FilterCategory(label: "Sort by", name: "sort", options:
            [            
                Filter(label: "Best Matched", value: "0", selected: true),
                Filter(label: "Distance", value: "1"),
                Filter(label: "Highest Rated", value: "2")
            ], type: FilterCategoryType.Single)
    ]
    
}