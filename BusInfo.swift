//
//  BusInfo.swift
//  RutgersBusApp
//
//  Created by Kalu on 1/1/16.
//  Copyright © 2016 Niral. All rights reserved.
//

import Foundation

struct BusInfo{
   // var direction:String
    var busRoute: String
    var prediction:[String]
}

struct BusStopInformation {
    var busStop:String
    var busStopInfo: [BusInfo]
}
