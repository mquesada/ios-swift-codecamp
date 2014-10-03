//
//  FiltersViewController.swift
//  yelp
//
//  Created by Maricel Quesada on 10/2/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {

    var delegate: FilterViewDelegate!
    var filterManager = FilterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filterManager.filterCategoryList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterCategory = self.filterManager.filterCategoryList[section]
        
        if (!filterCategory.expanded) {
            return 1
        }
        return filterCategory.options.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filterManager.filterCategoryList[section].label
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterCategory = self.filterManager.filterCategoryList[indexPath.section]
        let filter = filterCategory.options[indexPath.row]
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = filter.label
        
        if (filterCategory.expanded) {
            if (filterCategory.type == FilterCategoryType.Single) {
                if (filter.selected){
                    cell.accessoryView = UIImageView(image: UIImage(named: "Select"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Unselect"))
                }
            } else {
                let switchView = UISwitch()
                switchView.on = filter.selected
                cell.accessoryView = switchView
            }
        } else {
            cell.accessoryView = UIImageView(image: UIImage(named:"Expand"))
        }
        
        
        return cell
    }

}
