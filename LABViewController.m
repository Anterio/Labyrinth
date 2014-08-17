////   add header with Lives
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
    UIAttachmentBehavior * attachmentBehavior;
    
    UISnapBehavior *snapBehavior;
    
    UIView * ball;
    UIView * blackHole;
    UIView * blackHoleBackground;
    UIView * wall;
    UIView * wall4;
    UIView * wall5;
    
    UIButton * startButton;
    
    CGPoint * origin;
    
    float xRotation;
    float yRotation;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.frame = CGRectMake (0,0,self.view.frame.size.height, self.view.frame.size.width);
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [self showStartButton];
        
        
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        gravityBehavior = [[UIGravityBehavior alloc] init];
        [animator addBehavior:gravityBehavior];
        
        collisionBehavior = [[UICollisionBehavior alloc]init];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionDelegate = self;
        [animator addBehavior:collisionBehavior];
        
        ballBehavior = [[UIDynamicItemBehavior alloc] init];
        ballBehavior.density = 10;
        [animator addBehavior:ballBehavior];
        
        [animator addBehavior:attachmentBehavior];
        
        wallBehavior =[[UIDynamicItemBehavior alloc]init];
        wallBehavior.density = 1000000000000000;
        [animator addBehavior:wallBehavior];
        
        

        blackHoleBehavior = [[UIDynamicItemBehavior alloc] init];
        [animator addBehavior:blackHoleBehavior];
        blackHoleBehavior.density = 100000000000000;
    
       
        

    }
    return self;
}

- (void)setAngle:(CGFloat)angle magnitude:(CGFloat)magnitude
{
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    xRotation = yRotation = 0;
    [self updateGravity];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    NSLog(@"collision");
    //BOOL inBlackHole = [self isPoint:self.ball.center withInRadius:self.blackHole.frame.size.width / 2.0 ofPoint:self.blackHole.center]
    if ([item1 isEqual:blackHole] || [item2 isEqual:blackHole])
    {
        NSLog(@"black hole collision!!!");
        [collisionBehavior removeItem:blackHole];
        
        if ([item1 isEqual:ball] || [item2 isEqual:ball])
        {
            NSLog(@"ball just hit the blackhole!");
            [collisionBehavior removeItem:ball];
            [ballBehavior removeItem:ball];
            [gravityBehavior removeItem:ball];
    
            [UIView animateWithDuration:.8 animations:^{
                ball.center = blackHoleBackground.center;
            } completion:^(BOOL finished){
                [ball removeFromSuperview];
                
//                snapBehavior = [[UISnapBehavior alloc] initWithItem:@[wall,wall4] snapToPoint:blackHole.center];
//                [animator addBehavior:snapBehavior];
                
                snapBehavior = [[UISnapBehavior alloc] initWithItem:wall snapToPoint:blackHole.center];
                [animator addBehavior:snapBehavior];
                
                snapBehavior = [[UISnapBehavior alloc] initWithItem:wall4 snapToPoint:blackHole.center];
                [animator addBehavior:snapBehavior];
                
                snapBehavior = [[UISnapBehavior alloc] initWithItem:wall5 snapToPoint:blackHole.center];
                [animator addBehavior:snapBehavior];
                
                [UIView animateWithDuration:1.2 animations:^(void) {
                    blackHoleBackground.transform = CGAffineTransformScale(blackHoleBackground.transform, 100.0, 100.0);
                 
                
                    //                wall.transform = CGAffineTransformScale(wall.transform, 0.1, 0.1);
                   // wall.alpha = 0.0;
                } completion:^(BOOL finished) {
                }];
                [UIView animateWithDuration:.5 animations:^(void) {
                                        wall.alpha = 0.0;
                                        wall4.alpha = 0.0;
                                        wall5.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                }];

            }];
            
        }

        }
}
  
-(void) showStartButton
{
    
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-100)/2, 100, 100)];
    [startButton setTitle:@"START" forState:UIControlStateNormal];
    startButton.layer.cornerRadius = 50;
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    startButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:startButton];
}

-(void) startGame
{
    [startButton removeFromSuperview];
    
    [self createWalls];
    [self createBlackHole];
    [self createBall];
    
//    [self resetBricks];
//    [self createBall];
//    headerView.lives = 3;
//    headerView.score = 0;
    
}
-(void) createWalls
{
    wall = [[UIView alloc] initWithFrame:CGRectMake(70, -20, 60, 240)];
    wall.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
    wall.layer.cornerRadius = 10;
    [self.view addSubview:wall];
    NSLog(@"%@", wallBehavior);
    [wallBehavior addItem:wall];
    [collisionBehavior addItem:wall];
    
    
    wall4 = [[UIView alloc] initWithFrame:CGRectMake(315, 0, 60, 240)];
    wall4.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
    wall4.layer.cornerRadius = 10;
    [self.view addSubview:wall4];
    [wallBehavior addItem:wall4];
    [collisionBehavior addItem:wall4];
    
    wall5 = [[UIView alloc] initWithFrame:CGRectMake(450, 80, 120, 60)];
    wall5.backgroundColor = [UIColor colorWithRed:0.718f green:0.647f blue:0.498f alpha:1.0f];
    wall5.layer.cornerRadius = 10;
    [self.view addSubview:wall5];
    [wallBehavior addItem:wall5];
    [collisionBehavior addItem:wall5];
}
-(void) createBlackHole
{
    blackHoleBackground = [[UIView alloc] initWithFrame:CGRectMake(200, 220, 40, 40)];
    blackHoleBackground.backgroundColor = [UIColor blackColor];
    blackHoleBackground.layer.cornerRadius = 20;
    [self.view addSubview:blackHoleBackground];
    
    blackHole = [[UIView alloc] initWithFrame:CGRectMake(200, 220, 18, 18)];
    blackHole.backgroundColor = [UIColor blackColor];
    blackHole.center =blackHoleBackground.center;
    [self.view addSubview:blackHole];

    [blackHoleBehavior addItem:blackHole];
    [collisionBehavior addItem:blackHole];
}
-(void) createBall
{
    
    ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ball.center = self.view.center;
    ball.backgroundColor = [UIColor colorWithRed:0.988f green:0.059f blue:0.259f alpha:1.0f];
    ball.layer.cornerRadius = 20;
    
    [self.view addSubview:ball];
    [ballBehavior addItem:ball];
    [gravityBehavior addItem:ball];
    [collisionBehavior addItem:ball];
}

-(BOOL)prefersStatusBarHidden {return YES;}

@end





//            UIDynamicBehavior* extra = [[UIDynamicBehavior alloc] init];
//            UIGravityBehavior* blackHoleGravityBehavior = [[UIGravityBehavior alloc] init];
//            [blackHoleGravityBehavior addItem:wall];
//            blackHoleGravityBehavior.magnitude = 100000000000000;
//            blackHoleGravityBehavior.angle = 10;
//            [extra addChildBehavior:blackHoleGravityBehavior];
//            [animator addBehavior:extra];


