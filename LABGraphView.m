//
//  LABGraphView.m
//  Labyrinth
//
//  Created by Arthur Boia on 8/14/14.
//  Copyright (c) 2014 Arthur Boia. All rights reserved.
//

#import "LABGraphView.h"

@implementation LABGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.xPlots = [@[] mutableCopy];
        self.yPlots = [@[] mutableCopy];
        self.zPlots = [@[] mutableCopy];
        
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 10);
    
    for (NSNumber * number in self.xPlots)
    {
        NSInteger index = [self.xPlots indexOfObject:number];
        
        CGContextMoveToPoint(context, 10 * index, 0);
        CGContextAddLineToPoint(context, 10 * index, [number floatValue]);
    }
    
    CGContextStrokePath(context);
}


@end
//        LABGraphView * graphView = [[LABGraphView alloc] initWithFrame:self.view.frame];
//
//        CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//        [self.view addSubview:graphView];
//motionManager = [[CMMotionManager alloc] init];
//[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
    
    //   NSLog(@"x %f y %f z %f", motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
    
    
    
    
    
    //make min and max value
    
//    xRotation -=motion.rotationRate.x /30.0;
  //  yRotation +=motion.rotationRate.y /30.0;
    
    //[self updateGravity];
    
    //         if (graphView.xPlots.count > self.view.frame.size.height / 10.0)
    //         {
    //             [graphView.xPlots removeObjectAtIndex:0];
    //         }
    //
    //        [graphView.xPlots addObject:@(motion.rotationRate.x * 200)];
    //        [graphView setNeedsDisplay];
    
