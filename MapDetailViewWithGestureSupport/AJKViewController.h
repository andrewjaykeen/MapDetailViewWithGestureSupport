//
//  AJKViewController.h
//  MapDetailViewWithGestureSupport
//
//  Created by Andy Keen on 6/10/14.
//  Copyright (c) 2014 Andy Keen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AJKViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (void)adjustDetailView:(CGRect)frameRect;
@end
