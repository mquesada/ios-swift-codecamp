//
//  FiltersViewController.swift
//  yelp
//
//  Created by Maricel Quesada on 10/2/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var delegate: FilterViewDelegate!
    var filterManager: FilterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.whiteColor()
        
        if (filterCategory.expanded) {
            let filter = filterCategory.options[indexPath.row]
            cell.textLabel?.text = filter.label
            if (filterCategory.type == FilterCategoryType.Single || filterCategory.type == FilterCategoryType.Multiple) {
                if (filter.selected){
                    cell.accessoryView = UIImageView(image: UIImage(named: "Select"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Unselect"))
                }
            } else {
                let switchView = UISwitch()
                switchView.on = ("1" == filter.value)
                switchView.addTarget(self, action: "switchCategoryChanged:", forControlEvents: UIControlEvents.ValueChanged)
                cell.accessoryView = switchView
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
        } else {
            cell.textLabel?.text = filterCategory.options[filterCategory.selectedIndex].label
            cell.accessoryView = UIImageView(image: UIImage(named:"Expand"))
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filterCategory = self.filterManager.filterCategoryList[indexPath.section]

        let currentFilter = filterCategory.options[indexPath.row]
        
        if (filterCategory.expanded) {
            filterCategory.expanded = false
            if (filterCategory.type == FilterCategoryType.Single) {
                currentFilter.selected = true
                filterCategory.options[filterCategory.selectedIndex].selected = false
                filterCategory.selectedIndex = indexPath.row
            } else if (filterCategory.type == FilterCategoryType.Multiple) {
                currentFilter.selected = !currentFilter.selected
            }
        } else {
            filterCategory.expanded = true
        }
        self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func switchCategoryChanged(switchView: UISwitch) {
        let cell = switchView.superview as UITableViewCell
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let filterCategory = self.filterManager.filterCategoryList[indexPath.section]
            let filter = filterCategory.options[indexPath.row]
            filter.value = switchView.on ? "1" : "0"
        }
    }

    @IBAction func cancelFilters(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchWithFilters(sender: AnyObject) {
        self.delegate.filteringDone()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
