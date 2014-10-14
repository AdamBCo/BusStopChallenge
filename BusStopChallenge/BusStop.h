//
//  BusStop.h
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStop : NSObject
@property NSNumber *iDNumber;
@property NSNumber *uUID;
@property NSNumber *position;
@property NSString *urlString;
@property NSNumber *stopID;
@property NSString *cTAStopName;
@property NSString *busDirection;
@property NSMutableArray *routes;
@property NSNumber *wardNumber;
@property NSNumber *longitude;
@property NSNumber *latitude;

@end
