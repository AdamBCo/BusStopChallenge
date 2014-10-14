//
//  BusStopAnnotation.h
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BusStopAnnotation : NSObject <MKAnnotation>
@property (readonly) NSNumber *iDNumber;
@property (readonly) NSNumber *uUID;
@property (readonly) NSNumber *position;
@property (readonly) NSURL *urlString;
@property (readonly) NSNumber *stopID;
@property (readonly) NSString *cTAStopName;
@property (readonly) NSString *busDirection;
@property (readonly) NSMutableArray *routes;
@property (readonly) NSNumber *wardNumber;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;

-(instancetype)initWithJSONAndParse:(NSDictionary *)jSONDictionary;

@end
