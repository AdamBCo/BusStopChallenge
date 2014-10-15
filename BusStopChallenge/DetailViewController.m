//
//  DetailViewController.m
//  BusStopChallenge
//
//  Created by Adam Cooper on 10/14/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paceLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.selectedBusStop.title;
    self.routeLabel.text = self.selectedBusStop.routes;
    self.addressLabel.text = self.selectedBusStop.cTAStopName;
    if (self.selectedBusStop.paceCompliant == NO) {
        self.paceLabel.hidden = YES;
    }
    
}

- (IBAction)onCloseButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
