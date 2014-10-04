//
//  SearchViewController.swift
//  yelp
//
//  Created by Maricel Quesada on 9/30/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewDelegate {
    
    let defaultTerm = "Restaurants"
    let limit = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    var searchManager: SearchManager!    
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        self.searchManager = SearchManager()
        
        // Load some restaurants first
        self.searchBar.text = defaultTerm
        doSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchManager.result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        cell.business = self.searchManager.result[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.destinationViewController is UINavigationController) {
            let navigationController = segue.destinationViewController as UINavigationController
            if (navigationController.viewControllers[0] is FiltersViewController) {
                let filterController = navigationController.viewControllers[0] as FiltersViewController
                filterController.delegate = self
                filterController.filterManager = self.searchManager.filterManager
            }
        }
    }

    func filteringDone() {
        doSearch()
    }
    
    /* === SEARCH METHODS === */
    
    func doSearch() {
        self.searchManager.executeSearch(searchBar.text, limit: limit, offset: offset,
            before: self.showLoadingSpinner,
            after:{ () -> Void in },
            onSuccess: { () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
            },
            onFailure: self.showNetworkErrorMsg
        )
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch()
    }
    
    /* === LOADING SPINNER METHODS === */
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.color = UIColor.redColor()
        loading.labelText = "Searching...";
    }
    
    /* === REFRESH CONTROL METHODS === */
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.redColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.orangeColor()])
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        self.offset = 0
        if (searchBar.text.isEmpty){
            searchBar.text = defaultTerm
        }
        doSearch()
    }
    
    func showNetworkErrorMsg() {
        TSMessage.showNotificationWithTitle("Network Error", type: TSMessageNotificationType.Error)
    }

}
