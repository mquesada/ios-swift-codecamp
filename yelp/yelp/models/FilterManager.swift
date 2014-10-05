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
                Filter(label: "Offering a Deal", value: "0", selected: true)
            ], type: FilterCategoryType.OnOff, expanded: true),
        FilterCategory(label: "Categories", name: "category_filter", options:
            [
                Filter(label: "American (New)", value: "newamerican"),
                Filter(label: "American (Traditional)", value: "tradamerican"),
                Filter(label: "Argentine", value: "argentine"),
                Filter(label: "Breakfast & Brunch", value: "breakfast_brunch"),
                Filter(label: "Burgers", value: "burgers"),
                Filter(label: "Cafes", value: "cafes"),
                Filter(label: "Chinese", value: "chinese"),
                Filter(label: "Cuban", value: "cuban"),
                Filter(label: "French", value: "french"),
                Filter(label: "German", value: "german"),
                Filter(label: "Greek", value: "greek"),
                Filter(label: "Hawaiian", value: "hawaiian"),
                Filter(label: "Indian", value: "indpak"),
                Filter(label: "Irish", value: "irish"),
                Filter(label: "Italian", value: "italian"),
                Filter(label: "Japanese", value: "japanese"),
                Filter(label: "Mediterranean", value: "mediterranean"),
                Filter(label: "Mexican", value: "mexican"),
                Filter(label: "Peruvian", value: "peruvian"),
                Filter(label: "Pizza", value: "pizza"),
                Filter(label: "Seafood", value: "seafood"),
                Filter(label: "Spanish", value: "spanish"),
                Filter(label: "Sushi Bars", value: "sushi"),
                Filter(label: "Thai", value: "thai"),
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
    
    func getSelectedCategories() -> Dictionary<String, String> {
        var selectedCategories = Dictionary<String, String>()
        for category in filterCategoryList {
            let selectedOptions = category.selectedOptionsAsString()
            if (!selectedOptions.isEmpty) {
                selectedCategories[category.name] = selectedOptions
            }
        }
        return selectedCategories
    }
    
}