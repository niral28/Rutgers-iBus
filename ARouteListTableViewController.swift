//
//  ARouteListTableViewController.swift
//  RutgersBusApp
//
//  Created by Kalu on 1/3/16.
//  Copyright © 2016 Niral. All rights reserved.
//

import UIKit

class ARouteListTableViewController: UITableViewController {
    var currentRoute = String ();
    var currentRouteTag = String()
   // var currentInfo :BusStopInformation?
    //var activeRoutes = [BusInfo]()
    var timeResults = [[String: AnyObject]]();
    var busStopInfo = [BusInfo]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        //print("Ask for Route Details");
        jsonStopPredictions(currentRouteTag);
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func parseBusPredictions(let infos: [[String: AnyObject]]) {
        //var routeInfo = [BusInfo]()
        // print("starting to add to array predictions");
        //print(infos)
        // print("Bus Stop Info: \(stopTag)")
        //print("***************");
        
        for data in infos{
            
           // print("Info Data:")
            // print(data)
            //print("")
            if var name = data["title"] as? String where !name.isEmpty {
              //  print("title:\(name)");
               // print("")
                var predictionTimes = [String] ()
                
                
                if  !(data["predictions"] is NSNull) {
                    //print("predictions not null")
                    let preds = data["predictions"];
                    do {
                        let predictions = try preds as? [[String:AnyObject]]
                        //print(predictions)
                        for time in predictions! {
                            var mins = time["minutes"] as! String
                            if mins.isEqual("0"){
                                mins="<1";
                            }
                            //print("mins:\(mins)")
                            let secs = time["seconds"] as! String
                            //print("seconds:\(secs)")
                            predictionTimes.append("\(mins) (mins)")
                        }
                        
                        //print("")
                        // print(bPredictions!.count);
                        /*var aObject:AnyObject = preds
                        let anyMirror = Mirror(reflecting: aObject)
                        print(anyMirror.subjectType) */
                    }
                        
                    catch let error as JSONError {
                        print(error.rawValue)
                    } catch {
                        print(error)
                    }
                }
                else {
                    // "No Predictions Available"
                    // print("No Predictions Available");
                   // print("")
                    predictionTimes.append("No Predictions Available")
                }
                
                var newBusInfo = BusInfo(busRoute:name, prediction: predictionTimes)
                busStopInfo.append(newBusInfo);
            }
        }
       // print("Number of Bus Stops")
      //  print(busStopInfo.count)
        // outer for loop
        //var newBusStopInfo = BusStopInformation(busStop:stopTag, busStopInfo:routeInfo)
        //self.busStopInfo.append(newBusStopInfo);
    }// method
    
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }

    
    
    func jsonStopPredictions(let stopTag:String) {
        let stopTagNoSpaces = stopTag.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let urlPath = "http://runextbus.heroku.com/route/\(stopTagNoSpaces)"
        guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint"); return }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSArray else { throw JSONError.ConversionFailed }
                dispatch_async(dispatch_get_main_queue()) {
                    self.timeResults=json as! [[String : AnyObject]]
                    //  print(json);
                    //print("start parsing details")
                    self.parseBusPredictions(self.timeResults);
                    self.tableView.reloadData();
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
      //  print("Number of bus Stops at tableView:\(busStopInfo.count)")
            self.title=currentRoute
        
            return busStopInfo.count
    
    
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stopCell", forIndexPath: indexPath)
        //self.tableView.reloadData()
        // Configure the cell...
        var route = busStopInfo[indexPath.row];
        
        cell.textLabel?.text = route.busRoute
        cell.userInteractionEnabled = false;
        var allPredictions = ""
        
        // styling:
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
        if allPredictions.isEqual("No Predictions Available"){
          //  print("here for \(route)");
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor.grayColor();
            return cell;
        } else{
           // print("here for \(route)");
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.textLabel?.textColor = UIColor.blackColor();
            }
        

        return cell
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        busStopInfo.removeAll()
        jsonStopPredictions(currentRouteTag)
        self.tableView.reloadData()
        sender.endRefreshing()
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
