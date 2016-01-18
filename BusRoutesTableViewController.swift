//
//  BusRoutesTableViewController.swift
//  RutgersBusApp
//
//  Created by Kalu on 1/2/16.
//  Copyright © 2016 Niral. All rights reserved.
//

import UIKit

class BusRoutesTableViewController: UITableViewController {

    var currentStop = String();
    var currentInfo :BusStopInformation?
    var activeRoutes = [BusInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.backBarButtonItem!.tintColor = UIColor.whiteColor()
        
        for route in (currentInfo?.busStopInfo)!{
            for pred in route.prediction{
                if (pred.isEqual("No Predictions Available")){
                    break;
                }
                else{
                    activeRoutes.append(route);
                    break;
                }
            }
        }
        
            // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.title = currentStop
        return activeRoutes.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rCell", forIndexPath: indexPath)
        
        var route = activeRoutes[indexPath.row];
        
        cell.textLabel?.text = route.busRoute
        cell.userInteractionEnabled = false;
        if(route.prediction[0].isEqual("No Predictions Available")){
            print("here")
            cell.textLabel?.textColor = UIColor.grayColor();
        }
        
        var allPredictions = ""
            var count = 1;
            for pred in route.prediction{
                if count == route.prediction.count {
                    allPredictions += pred
                } else{
                    allPredictions += pred + " , "
                }
                count++
            }
     
        
            cell.detailTextLabel?.text = allPredictions;
        
        // Configure the cell...
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
