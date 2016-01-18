//
//  ActiveRoutesTableViewController.swift
//  RutgersBusApp
//
//  Created by Kalu on 1/3/16.
//  Copyright © 2016 Niral. All rights reserved.
//

import UIKit

class ActiveRoutesTableViewController: UITableViewController, UISearchResultsUpdating {
    var dataResults = [[String: AnyObject]]();
    var busStopRoutes = [String] ()
    var busStopRouteTags = [String]()
    var noData = false;
    var busRouteInfo = [BusRouteInfo] ()
    var filteredBusRoutes = [String]()
    var resultSearchController = UISearchController!()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController!.navigationBar.barTintColor = UIColor(red: 206/255, green: 17/255, blue: 38/255, alpha: 1)
        
       
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        jsonBusRoutes();
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.placeholder = "Search Routes"
        self.resultSearchController.searchBar.tintColor = UIColor(red: 206/255, green: 17/255, blue: 38/255, alpha: 1)
        // self.resultSearchController.h = "Search Routes"
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
        
        
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
            var temp = BusRouteInfo(busStop: "",stopTag: "");
            if let name = stop["title"] as? String {
                //print(name);
                self.busStopRoutes.append(name);
                temp.busStop = name;
            }
            if let tag = stop["tag"] as? String{
                self.busStopRouteTags.append(tag)
                temp.stopTag = tag;
            }
            self.busRouteInfo.append(temp);
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
       
        if self.resultSearchController.active {
            return self.filteredBusRoutes.count
        }
        else {
            if (busStopRoutes.count == 0){
                //print("No Data is:\(self.noData)");
                return 1;
            }
            //print("busStopCount:\(busStopRoutes.count)")
            //if busStopRoutes.count != 0 {
               // print("noData set to false");
                return busStopRoutes.count;
        }      //noData = false;
        //} else{
          //  print("noData set to true")
           // noData = true;
            //return 1;
        //}
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("routeCell", forIndexPath: indexPath) as UITableViewCell?
      //  print("status of noData:\(noData)");
       
        if self.resultSearchController.active {
                cell!.textLabel?.text = self.filteredBusRoutes[indexPath.row]
        }
        else {
            if (busStopRoutes.count == 0) {
               cell!.textLabel?.text = "No Active Routes";
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                cell!.textLabel?.textColor = UIColor.grayColor();
                cell!.userInteractionEnabled = false;
                return cell!;
            }
                cell!.textLabel?.text = busStopRoutes[indexPath.row]
            cell!.selectionStyle = UITableViewCellSelectionStyle.Default
            cell!.textLabel?.textColor = UIColor.blackColor();
            cell!.userInteractionEnabled = true;

        }
        // Configure the cell...
        return cell!
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
        if self.resultSearchController.active{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let selectedRoute = filteredBusRoutes[indexPath.row]
              //  print("Selected Route:\(selectedRoute)")
                var selectedTag = "";
                for tags in busRouteInfo{
                    if (tags.busStop.isEqual(selectedRoute)){
                        selectedTag = tags.stopTag;
                        break;
                    }
                }
               // print("Selected Tag:\(selectedTag)")
                
                secondScene.currentRoute = selectedRoute
                secondScene.currentRouteTag = selectedTag
                //pass on BusStopInformation to the next scene
                self.resultSearchController.active = false;
            }
        } else{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRoute = busStopRoutes[indexPath.row]
                let selectedRouteTag = busStopRouteTags[indexPath.row]
                secondScene.currentRoute = selectedRoute
                secondScene.currentRouteTag = selectedRouteTag
                //pass on BusStopInformation to the next scene
            }
        }
        // Pass the selected object to the new view controller.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredBusRoutes.removeAll(keepCapacity:false);
        let searchPredicate = NSPredicate(format:"SELF CONTAINS[c] %@", searchController.searchBar.text!);
        let array = (self.busStopRoutes as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredBusRoutes = array as! [String]
        self.tableView.reloadData()
    }

    
    @IBAction func refresh(sender: UIRefreshControl) {
        busRouteInfo.removeAll()
        busStopRoutes.removeAll()
        busStopRouteTags.removeAll()
        jsonBusRoutes()
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    


}
