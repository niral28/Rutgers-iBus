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
    var busStop:String = ""
    var busStopInfo: [BusInfo] = []
}

struct BusRouteInfo {
    var busStop:String
    var stopTag:String 
}

func encode<BusStopInformation>(var value: BusStopInformation) -> NSData {
    return withUnsafePointer(&value) { p in
        NSData(bytes: p, length: sizeofValue(value))
    }
}

func decode<BusStopInformation>(data: NSData) -> BusStopInformation {
    let pointer = UnsafeMutablePointer<BusStopInformation>.alloc(sizeof(BusStopInformation))
    data.getBytes(pointer, length: sizeof(BusStopInformation))
    
    return pointer.move()
}
