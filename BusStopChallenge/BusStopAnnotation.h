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
@property (readonly) NSString *routes;
@property (readonly) NSNumber *wardNumber;
@property (readonly) BOOL paceCompliant;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *subtitle;
@property (readonly) UIImage *iconImage;


-(instancetype)initWithJSONAndParse:(NSDictionary *)jSONDictionary;

@end
