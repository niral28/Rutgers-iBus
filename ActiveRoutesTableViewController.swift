//
//  ActiveRoutesTableViewController.swift
//  RutgersBusApp
//
//  Created by Kalu on 1/3/16.
//  Copyright © 2016 Niral. All rights reserved.
//

import UIKit

class ActiveRoutesTableViewController: UITableViewController {
    var dataResults = [[String: AnyObject]]();
    var busStopRoutes = [String] ()
    var busStopRouteTags = [String]()
    var noData = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonBusRoutes();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func parseBusRoutes(let stops: [[String: AnyObject]]){
        
        for stop in stops{
            if let name = stop["title"] as? String {
                //print(name);
                self.busStopRoutes.append(name);
                //jsonStopPredictions(name);
            }
            if let tag = stop["tag"] as? String{
                self.busStopRouteTags.append(tag)
            }
        }
        //print(busStopRoutes.count);
    }
    

    
    func jsonBusRoutes() {
        //print("entered parsing");
        let urlPath = "http://runextbus.heroku.com/active"
        guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint"); return }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData; self.noData = true }
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                
                if let stops = json["routes"] as? [[String: AnyObject]] {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dataResults=stops
                        // print(stops);
                        self.parseBusRoutes(self.dataResults);
                        self.tableView.reloadData();
                    }
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }.resume()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.title = "Routes"
        if (self.noData==true){
            //print("No Data is:\(self.noData)");
            return 1;
        }
        //print("busStopCount:\(busStopRoutes.count)")
        //if busStopRoutes.count != 0 {
           // print("noData set to false");
            return busStopRoutes.count;
            //noData = false;
        //} else{
          //  print("noData set to true")
           // noData = true;
            //return 1;
        //}
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("routeCell", forIndexPath: indexPath)
      //  print("status of noData:\(noData)");
        if (self.noData == true) {
           cell.textLabel?.text = "No Active Routes";
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor.grayColor();
            cell.userInteractionEnabled = false;
            return cell;
        }
            cell.textLabel?.text = busStopRoutes[indexPath.row]
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        var secondScene = segue.destinationViewController as! ARouteListTableViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRoute = busStopRoutes[indexPath.row]
            let selectedRouteTag = busStopRouteTags[indexPath.row]
            secondScene.currentRoute = selectedRoute
            secondScene.currentRouteTag = selectedRouteTag
            //pass on BusStopInformation to the next scene
        }
        // Pass the selected object to the new view controller.
    }
    
    
    
    @IBAction func refresh(sender: UIRefreshControl) {
        //jsonBusRoutes()
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    


}
