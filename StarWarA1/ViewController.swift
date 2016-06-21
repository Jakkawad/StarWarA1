//
//  ViewController.swift
//  StarWarA1
//
//  Created by admin on 6/21/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView:UITableView!
    
    var species:Array<StarWarsSpecies>?
    var speciesWrapper:SpeciesWrapper?
    var isLoadingSpecies = false
    //var imageCache:Dictionary<String, ImageSearchResult?>?
    
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
        if self.species == nil {
            return 0
        }
        return self.species!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell0 = tableView.dequeueReusableCellWithIdentifier("tableCell0")
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
        
        return cell0!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirstSpecies()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

