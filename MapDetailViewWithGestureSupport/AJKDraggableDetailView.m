//
//  AJKDraggableDetailView.m
//  MapDetailViewWithGestureSupport
//
//  Created by Andy Keen on 6/13/14.
//  Copyright (c) 2014 Andy Keen. All rights reserved.
//

#import "AJKDraggableDetailView.h"

#define bottomOffset 200.0
#define animDuration 0.5

@interface AJKDraggableDetailView () <UIGestureRecognizerDelegate>
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;
@end


@implementation AJKDraggableDetailView

CGPoint lastLocation;
int counter;

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupGestures];
    }
    return self;
}

// when loaded via nib
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // Initialization code
        [self setupGestures];
    }
    return self;
}


#pragma mark - public methods
- (IBAction)hideView
{
    CGRect finishRectHidden = CGRectMake(0, self.superview.frame.size.height+1, self.superview.frame.size.width,self.superview.frame.size.height);
    [self adjustDetailView:finishRectHidden];
}

- (IBAction)showView
{
    CGRect finishRectShown = CGRectMake(0, self.superview.frame.size.height-bottomOffset, self.superview.frame.size.width,self.superview.frame.size.height);
    [self adjustDetailView:finishRectShown];
}

-(void)showViewFullScreen
{
    CGRect finishRectShown = CGRectMake(0, 0, self.superview.frame.size.width,self.superview.frame.size.height);
    [self adjustDetailView:finishRectShown];
}

-(void)adjustDetailView:(CGRect)frameRect
{
    [UIView animateWithDuration:animDuration
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState & UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = frameRect;
                     }
                     completion:^(BOOL finished){
                     }];
}
 

#pragma mark - Swipe Gesture Setup/Actions

- (void)setupGestures
{
    if(!self.panRecognizer) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMade:)];
        [self.panRecognizer setMinimumNumberOfTouches:1];
        [self.panRecognizer setMaximumNumberOfTouches:1];
        [self.panRecognizer setDelegate:self];
        
        [self addGestureRecognizer:self.panRecognizer];
    }
}

- (void) gestureMade:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint vel = [gestureRecognizer velocityInView:self];
    (vel.y > 0) ? counter++ : counter--;  // user is either dragging UP or DOWN
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        counter = 0;
    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        self.center = CGPointMake(lastLocation.x, lastLocation.y + translation.y);
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(counter > 0) {
            if(self.frame.origin.y > self.superview.frame.size.height-bottomOffset) {
                [self hideView];
            }
            else {
                [self showView];
            }
        }
        else {
            [self showViewFullScreen];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastLocation = self.center;  // Remember original location
}



@end
