//
//  ViewController.swift
//  StarWarA1
//
//  Created by admin on 6/21/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView:UITableView!
    
    var species:Array<StarWarsSpecies>?
    var speciesWrapper:SpeciesWrapper?
    var isLoadingSpecies = false
    
    var speciesSearchResults:Array<StarWarsSpecies>?
    /*
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your search here!"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    */
    func loadFirstSpecies() {
        isLoadingSpecies = true
        StarWarsSpecies.getSpecies({ (speciesWrapper, error) in
            if error != nil {
                // TODO: improved error handling
                self.isLoadingSpecies = false
                let alert = UIAlertController(title: "Error", message: "Could not load first species \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.addSpeciesFromWrapper(speciesWrapper)
            self.isLoadingSpecies = false
            self.tableView?.reloadData()
            
        })
    }
    
    func loadMoreSpecies() {
        self.isLoadingSpecies = true
        if self.species != nil && self.speciesWrapper != nil && self.species!.count < self.speciesWrapper!.count {
            StarWarsSpecies.getMoreSpecies(self.speciesWrapper, completionHandler: { (moreWrapper, error) in
                if error != nil {
                    // TODO: improved errro handling
                    self.isLoadingSpecies = false
                    let alert = UIAlertController(title: "Error", message: "Could not load more species \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                }
                print("got more!")
                self.addSpeciesFromWrapper(moreWrapper)
                self.isLoadingSpecies = false
                self.tableView?.reloadData()
            })
        }
    }
    
    func addSpeciesFromWrapper(wrapper: SpeciesWrapper?) {
        self.speciesWrapper = wrapper
        if self.species == nil {
            self.species = self.speciesWrapper?.species
        } else if self.speciesWrapper != nil && self.speciesWrapper!.species != nil {
            self.species = self.species! + self.speciesWrapper!.species!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        /*
        if self.species == nil {
            return 0
        }
        return self.species!.count
        */
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.speciesSearchResults?.count ?? 0
        } else {
            return self.species?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell0 = tableView.dequeueReusableCellWithIdentifier("tableCell0")
        var cell0 = self.tableView!.dequeueReusableCellWithIdentifier("tableCell0")
        /*
        if self.species != nil && self.species!.count >= indexPath.row
        {
            let species = self.species![indexPath.row]
            cell0?.textLabel?.text = species.name
            cell0?.detailTextLabel?.text = species.classification
            
            // See if we need to load more species
            let rowsToLoadFromBottom = 5
            let rowsLoaded = self.species!.count
            if (!self.isLoadingSpecies && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))) {
                let totalRows = self.speciesWrapper!.count!
                let remainingSpeciesToLoad = totalRows - rowsLoaded
                if  (remainingSpeciesToLoad > 0) {
                    self.loadMoreSpecies()
                }
            }
        }
        */
        
        var arrayOfSpecies:Array<StarWarsSpecies>?
        if tableView == self.searchDisplayController!.searchResultsTableView {
            arrayOfSpecies = self.speciesSearchResults
        } else {
            arrayOfSpecies = self.species
        }
        if arrayOfSpecies != nil && self.species!.count >= indexPath.row {
            let species = arrayOfSpecies![indexPath.row]
            cell0!.textLabel?.text = species.name
            cell0!.detailTextLabel?.text = species.language
        }
        /*
        if arrayOfSpecies != nil && arrayOfSpecies!.count >= indexPath.row {
            let species = arrayOfSpecies![indexPath.row]
            cell0?.textLabel?.text = species.name
            cell0?.detailTextLabel?.text = " "
            cell0?.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell0?.imageView?.image = nil
            /*
            if let name = species.name {
                if let cachedImageResult = imageCache![name] {
                    // TODO: custom cell with class assigned for custom view?
                    cell0?.imageView?.image = cachedImageResult!.image
                    if let attribution = cachedImageResult?.fullAttribution() {
                        if attribution.isEmpty == false {
                            cell0?.detailTextLabel?.text = attribution
                        }
                    }
                }
            } else {
                
            }
            */
        }
        */
        
        if tableView != self.searchDisplayController!.searchResultsTableView {
            // See if we need to load more species
            let rowsToLoadFromBottom = 5
            let rowsLoaded = self.species!.count
            if (!self.isLoadingSpecies && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))) {
                let totalRows = self.speciesWrapper!.count!
                let remainingSpeciesToLoad = totalRows - rowsLoaded
                if (remainingSpeciesToLoad > 0) {
                    self.loadMoreSpecies()
                }
            }
        }
        
    
        return cell0!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let detailVC = segue.destinationViewController as? SpeciesDetailViewController {
            // gotta check if we're currently searching
            if self.searchDisplayController!.active {
                let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow
                if indexPath != nil {
                    detailVC.species = (self.speciesSearchResults?[indexPath!.row])!
                }
            } else {
                let indexPath = self.tableView?.indexPathForSelectedRow
                if indexPath != nil {
                    detailVC.species = (self.species?[indexPath!.row])!
                }
            }
        }
    }
    
    // MARK: Search
    
    //func filterContentForSearchText(searchText: String) {
    func filterContentForSearchText(searchText: String, scope: Int) {
        // Filter the array using the filter method
        if self.species == nil {
            self.speciesSearchResults = nil
            return
        }
        self.speciesSearchResults = self.species!.filter({( aSpecies: StarWarsSpecies) -> Bool in
        // to start, let's just search by name
            //return aSpecies.name!.rangeOfString(searchText) != nil
        //return aSpecies.name!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        // pick the field to search
        var fieldToSearch: String?
            switch (scope) {
            case (0):
                fieldToSearch = aSpecies.name
            case (1):
                fieldToSearch = aSpecies.language
            case (2):
                fieldToSearch = aSpecies.classification
            default:
                fieldToSearch = nil
            }
            if fieldToSearch == nil {
                self.speciesSearchResults = nil
                return false
            }
            return fieldToSearch!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        //self.filterContentForSearchText(searchString!)
        let selectedIndex = controller.searchBar.selectedScopeButtonIndex
        self.filterContentForSearchText(searchString!, scope: selectedIndex)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let searchString = controller.searchBar.text
        self.filterContentForSearchText(searchString!, scope: searchOption)
        return true
    }
    
    /*
    //func filterContentForSearchText(searchText: String) {
    func filterContentForSearchText(searchText: String, scope: Int) {
        // Filter the array using the filter method
        if self.species == nil {
            self.speciesSearchResults = nil
            return
        }
        self.speciesSearchResults = self.species!.filter({( aSpecies: StarWarsSpecies) -> Bool in
        // pick the field to search
            var fieldTosearch: String?
            
            switch (scope) {
            case (0):
                fieldTosearch = aSpecies.name
            case (1):
                fieldTosearch = aSpecies.language
            case (2):
                fieldTosearch = aSpecies.classification
            default:
                fieldTosearch = nil
            }
            
            //fieldTosearch = aSpecies.name
            if fieldTosearch == nil {
                self.speciesSearchResults = nil
                return false
            }
            return fieldTosearch!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        //self.filterContentForSearchText(searchString)
        let selectedIndex = controller.searchBar.selectedScopeButtonIndex
        self.filterContentForSearchText(searchString!, scope: selectedIndex)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let searchString = controller.searchBar.text
        self.filterContentForSearchText(searchString!, scope: searchOption)
        return true
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirstSpecies()
        
        //createSearchBar()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

