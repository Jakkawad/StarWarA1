//
//  SpeciesDetailViewController.swift
//  StarWarA1
//
//  Created by admin on 6/22/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import UIKit

class SpeciesDetailViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    
    var species:StarWarsSpecies?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.displaySpeciesDetails()
    }
    
    func displaySpeciesDetails() {
        self.lblDescription.text = ""
        if self.species == nil {
            return
        }
        
        //lblDescription.text = species?.name
        if let name = self.species!.name {
            self.title = name
            if let language = self.species!.language {
                //self.lblDescription.text += "Member of the \(name) species speak \(language)."
                self.lblDescription!.text! += "Member of the \(name) species speak \(language)."
            }
            
            if self.species!.averageHeight != nil {
                self.lblDescription!.text! += "The \(self.species!.name!) can be identified by their height, typically \(self.species!.averageHeight!)cm."
            }
            //print(species?.films)
            let b = species?.films
            print("B\(b!.count)")
            for a in (species?.films)! {
                print(a)
            }
        }
        /*
        if let name = self.species!.name {
            self.title = name
            if let language = self.species!.language {
                self.lblDescription.text += "Members of the \(name) species speak \(language)."
            }
            
            if let height = self.species!.averageHeight {
                self.lblDescription.text += "The \(self.species?.name!) can be identified by their height, typically \(self.species!.averageHeight!) cm."
            }
            
            var eyeColors:String?
            if let colors = self.species!.eyeColors {
                eyeColors = ", ".join(colors)
            }
            
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
