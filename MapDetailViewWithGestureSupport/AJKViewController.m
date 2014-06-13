//
//  AJKViewController.m
//  MapDetailViewWithGestureSupport
//
//  Created by Andy Keen on 6/10/14.
//  Copyright (c) 2014 Andy Keen. All rights reserved.
//

#import "AJKViewController.h"
#import "AJKDraggableDetailView.h"


@interface AJKViewController ()
@property (nonatomic) AJKDraggableDetailView *detailView;
@end

@implementation AJKViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPins];
    // [self setupGestures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addPins
{
    NSArray *locations = @[
                           [[CLLocation alloc] initWithLatitude:44 longitude:-121],
                           [[CLLocation alloc] initWithLatitude:44 longitude:-100],
                           [[CLLocation alloc] initWithLatitude:40 longitude:-110]
                           ];
    NSMutableArray *pinAnnotations = [NSMutableArray array];
    for(int i = 0; i < [locations count]; ++i)
    {
        CLLocation *coord = [locations objectAtIndex:i];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:[coord coordinate]];
        [pinAnnotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:pinAnnotations];
    
}



#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"redpin"];
    newAnnotation.pinColor = MKPinAnnotationColorGreen;
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout = NO;
    return newAnnotation;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    view.pinColor = MKPinAnnotationColorGreen;
    [self.detailView hideView];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    view.pinColor = MKPinAnnotationColorRed;
    
    // lazy load the detailView
    if(!self.detailView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyDetailView" owner:self options:nil];
        self.detailView = (AJKDraggableDetailView *)[nib objectAtIndex:0];
        
        // start out with view completely hidden
        self.detailView.frame = CGRectMake(0, self.view.frame.size.height+1, self.view.frame.size.width,self.view.frame.size.height);
        
        [self.view addSubview:self.detailView];
    }
    
    [self.detailView showView];
}



@end
