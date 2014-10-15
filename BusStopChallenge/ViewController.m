//
//  ViewController.m
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "ViewController.h"
#import "BusStopAnnotation.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property CLLocationManager *locationManager;
@property BusStopAnnotation *bustStop;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapListSegmentedController;
@property NSMutableArray *busArray;
@property (weak, nonatomic) IBOutlet UITableView *busStopTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.busArray = [NSMutableArray array];
    self.locationManager.delegate = self;
    
    
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *jsonError = nil;
        NSDictionary *parsedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *results = [parsedResults valueForKey:@"row"];
        for (NSDictionary *result in results){
            BusStopAnnotation *busStopInfo = [[BusStopAnnotation alloc] initWithJSONAndParse:result];
            [self.mapView addAnnotation:busStopInfo];
            [self.busArray addObject:busStopInfo];
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        }
        [self.busStopTableView reloadData];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    BusStopAnnotation *myBusStop = (BusStopAnnotation *) annotation;
    
    // If a new annotation is created
    if (annotationView == nil) {
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:myBusStop reuseIdentifier:@"MyAnnotation"];
        
        // Annotation's color
        if (myBusStop.paceCompliant == YES) {
            annotationView.pinColor = MKPinAnnotationColorPurple;
        }
        else {
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        
    }
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cta_logo"]];
    return annotationView;
}


-(IBAction)indexChange:(UISegmentedControl *)segmentedControl{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            [UIView animateWithDuration:0.3 animations:^{
                self.busStopTableView.alpha = 1.0;
            }];
            break;
        }
        case 1:{
            [UIView animateWithDuration:0.3 animations:^{
                self.busStopTableView.alpha = 0.0;
            }];
            break;
        }
        default:
            break;
    }
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[BusStopAnnotation class]]){
        [self performSegueWithIdentifier:@"DetailVC" sender:view];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender{
    if ([segue.identifier isEqualToString:@"DetailVC"])
    {
        DetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.selectedBusStop = sender.annotation;
        [destinationViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BusStopAnnotation *busStop = [self.busArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = busStop.title;
    cell.detailTextLabel.text = busStop.routes;
    cell.imageView.image = [UIImage imageNamed:@"cta_logo"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.busArray.count;
    
}

@end
