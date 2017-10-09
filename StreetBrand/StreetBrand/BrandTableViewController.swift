//
//  BrandTableViewController.swift
//  StreetBrand
//
//  Created by 杨芷一 on 10/8/17.
//  Copyright © 2017 杨芷一. All rights reserved.
//

import UIKit
import os.log

class BrandTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var brands = [Brand]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedBrands = loadBrands() {
            brands += savedBrands
        }
        else {
            // Load the sample data.
            loadSampleBrands()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return brands.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BrandTableViewCell"
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BrandTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BrandTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let brand = brands[indexPath.row]
        
        cell.nameLabel.text = brand.name
        cell.photoImageView.image = brand.photo
        cell.ratingControl.rating = brand.rating
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            brands.remove(at: indexPath.row)
            saveBrands()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new brand.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let brandDetailViewController = segue.destination as? BrandViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBrandCell = sender as? BrandTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBrandCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBrand = brands[indexPath.row]
            brandDetailViewController.brand = selectedBrand
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK:Action
    @IBAction func unwindToBrandList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BrandViewController, let brand = sourceViewController.brand {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                brands[selectedIndexPath.row] = brand
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: brands.count, section: 0)
                
                brands.append(brand)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveBrands()
        }
    }
    //MARK: Private Methods
    
    private func loadSampleBrands() {
        let photo1 = UIImage(named: "brand1")
        let photo2 = UIImage(named: "brand2")
        let photo3 = UIImage(named: "brand3")
        
        guard let brand1 = Brand(name: "Carhartt", photo: photo1, rating: 4)
            else {
            fatalError("Unable to instantiate brand1")
        }
        
        guard let brand2 = Brand(name: "Wtaps", photo: photo2, rating: 5)
            else {
            fatalError("Unable to instantiate brand2")
        }
        
        guard let brand3 = Brand(name: "Stussy", photo: photo3, rating: 3)
            else {
            fatalError("Unable to instantiate brand2")
        }
        brands += [brand1, brand2, brand3]
    }
    private func saveBrands() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(brands, toFile: Brand.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Brands successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save brands...", log: OSLog.default, type: .error)
        }
        
    }
    private func loadBrands() -> [Brand]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Brand.ArchiveURL.path) as? [Brand]
    }

}
