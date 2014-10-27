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
@property NSMutableArray *busArray;
@property (weak, nonatomic) IBOutlet UITableView *busStopTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapListToggleButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.busArray = [NSMutableArray array];
    [self.mapView showsUserLocation];
    
    self.locationManager.delegate = self;
    self.mapListToggleButton.image = [UIImage imageNamed:@"map_icon"];
    self.mapListToggleButton.tag = 1;

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
            NSLog(@"%@",busStopInfo.title);
        }
        [self.busStopTableView reloadData];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cta_logo"]];
    BusStopAnnotation *myBusStop = (BusStopAnnotation *) annotation;
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:myBusStop reuseIdentifier:@"MyAnnotation"];
        if (myBusStop.paceCompliant == YES) {
            annotationView.pinColor = MKPinAnnotationColorPurple;
        }
        else {
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
    }
    return annotationView;
}

- (IBAction)onMapListToggleButtonPressed:(UIBarButtonItem *)mapViewListViewToggle {
    
    if(mapViewListViewToggle.tag == 0) {
       self.mapListToggleButton.image = [UIImage imageNamed:@"map_icon"];
        [UIView animateWithDuration:0.3 animations:^{
            self.busStopTableView.alpha = 1.0;
            self.mapView.alpha = 0.0;
        }];
        self.mapListToggleButton.tag = 1;

   } else if(mapViewListViewToggle.tag == 1){
       self.mapListToggleButton.image = [UIImage imageNamed:@"menu"];
       [UIView animateWithDuration:0.3 animations:^{
           self.busStopTableView.alpha = 0.0;
           self.mapView.alpha = 1.0;
           [self.mapView showAnnotations:self.mapView.annotations animated:YES];
       }];
       self.mapListToggleButton.tag = 0;
   }

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[BusStopAnnotation class]]){
        [self performSegueWithIdentifier:@"DetailVC" sender:view];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"`"])
    {
        MKAnnotationView *annotView = (MKAnnotationView*)sender;
        DetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.selectedBusStop = annotView.annotation;
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
