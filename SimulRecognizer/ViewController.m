//
//  ViewController.m
//  SimulRecognizer
//
//  Created by Ngô Sỹ Trường on 5/5/16.
//  Copyright © 2016 ngotruong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController
{
    UIImageView* rugby;
    NSTimer *timer;
    NSDate *whenBullEyeBecomeBlue;
    UIPinchGestureRecognizer *pinch;
    UIRotationGestureRecognizer *rotate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    rugby = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rugbyOriginal.png"]];
    rugby.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    rugby.multipleTouchEnabled = true;
    rugby.userInteractionEnabled = true;
    [self.view addSubview:rugby];
    
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchMe:) ];
    pinch.delegate = self;
    [rugby addGestureRecognizer:pinch];
    
    rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotate:)];
    rotate.delegate = self ;
    
    [rugby addGestureRecognizer:rotate];
    
//    [rotate requireGestureRecognizerToFail:pinch];
//    
//     [pinch requireGestureRecognizerToFail:rotate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(loop)
                                           userInfo:nil
                                            repeats:true];
}

-(void) loop {
    if (whenBullEyeBecomeBlue != nil) {
        NSTimeInterval timeInterval = [whenBullEyeBecomeBlue timeIntervalSinceNow];
        if (-timeInterval > 0.2) {
            whenBullEyeBecomeBlue = nil;
            rugby.image = [UIImage imageNamed:@"rugbyOriginal.png"];
        }
    }
}

- (void) onRotate: (UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation);
        gestureRecognizer.rotation = 0;
        NSLog(@"rotate");
    }
}

- (void) pinchMe: (UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        gestureRecognizer.view.transform = CGAffineTransformScale(gestureRecognizer.view.transform, gestureRecognizer.scale, gestureRecognizer.scale);
        gestureRecognizer.scale = 1.0;
        NSLog(@"pinch");
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return true;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]] &&
//        [otherGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
//        return false;
//    } else {
//        return true;
//    }
//}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]] &&
//        [otherGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
//        return false;
//    } else {
//        return true;
//    }
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        return true;
    } else {
        return false;
    }
    
}

@end
