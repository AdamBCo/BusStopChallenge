//
//  ViewController.m
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "ViewController.h"
#import "BusStop.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property NSMutableArray *busStopArray;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *bustStopAnnotation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.busStopArray = [NSMutableArray array];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *jsonError = nil;
        NSDictionary *parsedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *results = [parsedResults valueForKey:@"row"];
        
        for (NSDictionary *result in results) {
            BusStop *busStop = [[BusStop alloc] init];
            busStop.iDNumber = [result objectForKey:@"_id"];
            busStop.uUID = [result objectForKey:@"_uuid"];
            busStop.position = [result objectForKey:@"_position"];
            busStop.urlString = [result objectForKey:@"_address"];
            busStop.stopID = [result objectForKey:@"stop_id"];
            busStop.cTAStopName = [result objectForKey:@"cta_stop_name"];
            busStop.busDirection = [result objectForKey:@"direction"];
            busStop.routes = [result objectForKey:@"routes"];
            busStop.wardNumber = [result objectForKey:@"ward"];
            busStop.longitude = [result objectForKey:@"longitude"];
            busStop.latitude = [result objectForKey:@"latitude"];
            [self.busStopArray addObject:busStop];
        }
        [self addbusStopPins];
    }];
}

-(void)addbusStopPins{
    
    for (BusStop *busStop in self.busStopArray) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = busStop.latitude.doubleValue;
        coordinate.longitude = busStop.longitude.doubleValue;
        self.bustStopAnnotation = [[MKPointAnnotation alloc] init];
        self.bustStopAnnotation.coordinate = coordinate;
        self.bustStopAnnotation.title = busStop.cTAStopName;
        [self.mapView addAnnotation:self.bustStopAnnotation];
    }
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    MKCoordinateRegion region;
    region.center = center;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

@end
