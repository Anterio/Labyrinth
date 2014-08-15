////   How do I make the corner Radius only on the sides I want?
/////  Why did all my bricks black out when I stacked them
////    Would "sendSubviewToBack" work
/////
/////
////





//
//  LABViewController.m
//  Labyrinth
//
//  Created by Arthur Boia on 8/14/14.
//  Copyright (c) 2014 Arthur Boia. All rights reserved.
//

#import "LABViewController.h"
#import "LABGraphView.h"
#import <CoreMotion/CoreMotion.h>

@interface LABViewController () <UICollisionBehaviorDelegate>

@end

@implementation LABViewController
{
    CMMotionManager * motionManager;
    
    UIDynamicAnimator * animator;
    
    UIGravityBehavior * gravityBehavior;
    UICollisionBehavior * collisionBehavior;
    
    UIDynamicItemBehavior * ballBehavior;
    UIDynamicItemBehavior * wallBehavior;
    UIDynamicItemBehavior * blackHoleBehavior;
    
    UIView * ball;
    UIView * blackHole;
    UIView * blackHoleBackground;
    
    CGPoint * origin;
    
    float xRotation;
    float yRotation;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        ballBehavior = [[UIDynamicItemBehavior alloc] init];
        [animator addBehavior:ballBehavior];
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        gravityBehavior = [[UIGravityBehavior alloc] init];
        [animator addBehavior:gravityBehavior];
        
        
        
        collisionBehavior = [[UICollisionBehavior alloc]init];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
        [animator addBehavior:collisionBehavior];
        
//        [collisionBehavior addBoundaryWithIdentifier:@"leftwall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, SCREEN_HEIGHT)];
        
        self.view.frame = CGRectMake (0,0,self.view.frame.size.height, self.view.frame.size.width);
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        
        ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        ball.center = self.view.center;
        ball.backgroundColor = [UIColor colorWithRed:0.988f green:0.059f blue:0.259f alpha:1.0f];
        ball.layer.cornerRadius = 20;
        [self.view addSubview:ball];
        [ballBehavior addItem:ball];
        
        [gravityBehavior addItem:ball];
        [collisionBehavior addItem:ball];
        
        wallBehavior =[[UIDynamicItemBehavior alloc]init];
        wallBehavior.density = 100000000;
        [animator addBehavior:wallBehavior];
        
        blackHole = [[UIView alloc] initWithFrame:CGRectMake(200, 220, 5, 5)];
        blackHole.backgroundColor = [UIColor blackColor];
        blackHole.layer.cornerRadius = 20;
        [self.view addSubview:blackHole];
        [blackHole addSubview:ball];
        [ballBehavior addItem:blackHole];
        [collisionBehavior addItem:blackHole];
        
        blackHoleBackground = [[UIView alloc] initWithFrame:CGRectMake(200, 220, 40, 40)];
        blackHoleBackground.backgroundColor = [UIColor blackColor];
        blackHoleBackground.layer.cornerRadius = 20;
        [self.view addSubview:blackHoleBackground];
        
        blackHoleBehavior = [[UIDynamicItemBehavior alloc] init];
        [animator addBehavior:blackHoleBehavior];
        blackHoleBehavior.density = 100000000000000;
        [blackHoleBehavior addItem:blackHole];
        
        UIView * wall = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 60, 240)];
        wall.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        wall.layer.cornerRadius = 10;
        [self.view addSubview:wall];
        
        UIView * wall2 = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 60, 100)];
        wall2.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        [self.view addSubview:wall2];
        
        UIView * wall3 = [[UIView alloc] initWithFrame:CGRectMake(315, 0, 60, 100)];
        wall3.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        [self.view addSubview:wall3];
        
        UIView * wall4 = [[UIView alloc] initWithFrame:CGRectMake(315, 0, 60, 240)];
        wall4.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        wall4.layer.cornerRadius = 10;
        [self.view addSubview:wall4];
        
        UIView * wall5 = [[UIView alloc] initWithFrame:CGRectMake(450, 80, 120, 60)];
        wall5.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        wall5.layer.cornerRadius = 10;
        [self.view addSubview:wall5];
        
        UIView * wall6 = [[UIView alloc] initWithFrame:CGRectMake(480, 80, 90, 60)];
        wall6.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
        [self.view addSubview:wall6];
        

        [collisionBehavior addItem:wall];
        [wallBehavior addItem:wall];
        
        [collisionBehavior addItem:wall4];
        [wallBehavior addItem:wall4];
        
        [wallBehavior addItem:wall5];
        [collisionBehavior addItem:wall5];

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
        xRotation -=motion.rotationRate.x /30.0;
        yRotation +=motion.rotationRate.y /30.0;
            
        [self updateGravity];
    }];
    
}

-(void)updateGravity
{
    //this is what changes the gravity and makes it so the ball can move around.  EVERY TIME it changes direction of gravity changes
    gravityBehavior.gravityDirection = CGVectorMake(xRotation, yRotation);
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    xRotation = yRotation = 0;
    [self updateGravity];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{

    [collisionBehavior removeItem:ball];
    [ballBehavior removeItem:ball];
    [ball removeFromSuperview];
    
    
//    [UIView animateWithDuration:.3 animations:^{
//        ball.alpha = 0;
//    completion:^(BOOL finished){
//        [ball removeFromSuperview];
//    }];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        ball.center = origin;
//    }];

}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)prefersStatusBarHidden {return YES;}
@end
