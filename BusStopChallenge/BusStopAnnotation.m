//
//  BusStopAnnotation.m
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "BusStopAnnotation.h"

@implementation BusStopAnnotation {
    NSDictionary *json;
}

-(instancetype)initWithJSONAndParse:(NSDictionary *)jSONDictionary{
    self = [super init];
    if (self) {
        json = jSONDictionary;
    }
    return self;
}

-(NSNumber *) iDNumber{
    return json[@"_id"];
}
-(NSNumber *)uUID{
    return json [@"_uuid"];
}
-(NSNumber *)position{
    return json [@"_position"];
}
-(NSNumber *)urlString{
    return json [@"_address"];
}
-(NSNumber *)stopID{
    return json [@"stop_id"];
}
-(NSString *)cTAStopName{
    return json [@"cta_stop_name"];
}
-(NSString *)busDirection{
    return json [@"direction"];
}
-(NSMutableArray *)routes{
    return json [@"routes"];
}
-(NSNumber *) wardNumber{
    return json[@"ward"];
}

-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = [json[@"latitude"]doubleValue];
    if ([json[@"longitude"]doubleValue] < 0) {
        newCoordinate.longitude = [json[@"longitude"]doubleValue];
    } else {
        newCoordinate.longitude = -[json[@"longitude"]doubleValue];
    }
    return newCoordinate;
}

-(NSString *)title{
    return self.cTAStopName;
}


@end
