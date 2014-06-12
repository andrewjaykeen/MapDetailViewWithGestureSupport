//
//  AJKViewController.m
//  MapDetailViewWithGestureSupport
//
//  Created by Andy Keen on 6/10/14.
//  Copyright (c) 2014 Andy Keen. All rights reserved.
//

#import "AJKViewController.h"

#define bottomOffset 200.0
#define animDuration 0.5

@interface AJKViewController () <UIGestureRecognizerDelegate>
@property (nonatomic) UIView *detailView;
@end

@implementation AJKViewController

CGPoint lastLocation;
int counter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPins];
    [self setupGestures];
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

- (BOOL)detailViewIsVisible
{
    return self.detailView.frame.origin.y >= 0 && self.detailView.frame.origin.y < self.view.frame.size.height;
}

-(void)hideDetailView
{
    CGRect finishRectHidden = CGRectMake(0, self.view.frame.size.height+1, self.view.frame.size.width,self.view.frame.size.height);
    [self adjustDetailView:finishRectHidden];
}

-(void)showDetailView
{
    CGRect finishRectShown = CGRectMake(0, self.view.frame.size.height-bottomOffset, self.view.frame.size.width,self.view.frame.size.height);
    [self adjustDetailView:finishRectShown];
}

-(void)showDetailViewFullScreen
{
    CGRect finishRectShown = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    [self adjustDetailView:finishRectShown];
}

-(void)adjustDetailView:(CGRect)frameRect
{
    [UIView animateWithDuration:animDuration
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState & UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.detailView.frame = frameRect;
                     }
                     completion:^(BOOL finished){
                     }];
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
    [self hideDetailView];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    view.pinColor = MKPinAnnotationColorRed;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    // lazy load the detailView
    if(!self.detailView)
    {
        self.detailView = [[UIView alloc] initWithFrame:applicationFrame];
        self.detailView.backgroundColor = [UIColor grayColor];
        self.detailView.frame = CGRectMake(0, self.view.frame.size.height+1, self.view.frame.size.width,self.view.frame.size.height);
        
        // add a button for testing sake
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(hideDetailView)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Hide View" forState:UIControlStateNormal];
        button.frame = CGRectMake(230.0, 20.0, 70.0, 40.0);
        button.backgroundColor = [UIColor whiteColor];
        [self.detailView addSubview:button];
        
        [self.view addSubview:self.detailView];
    }

    [self showDetailView];
}



#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMade:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}


- (void) gestureMade:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint vel = [gestureRecognizer velocityInView:self.detailView];
    (vel.y > 0) ? counter++ : counter--;  // user is either dragging UP or DOWN
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        counter = 0;
    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        self.detailView.center = CGPointMake(lastLocation.x, lastLocation.y + translation.y);
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(counter > 0) {
            if(self.detailView.frame.origin.y > self.view.frame.size.height-bottomOffset) {
                [self hideDetailView];
            }
            else {
                [self showDetailView];
            }
        }
        else {
            [self showDetailViewFullScreen];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastLocation = self.detailView.center;  // Remember original location
}


@end
