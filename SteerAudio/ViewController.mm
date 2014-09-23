//
//  ViewController.m
//  SteerAudio
//
//  Created by Philadelphia Game Lab on 7/30/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "ViewController.h"
#include "SteeringWheel.h"

@interface ViewController ()


@end

@implementation ViewController

@synthesize  valueLabel, azimuth, elevation, audioObj1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 525, 120, 30)];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.textColor = [UIColor lightGrayColor];
    //valueLabel.backgroundColor = [UIColor lightGrayColor];
    valueLabel.text = @"FROM SONIC";
    [self.view addSubview:valueLabel];
    
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startDeviceMotionUpdates];
    // timer = [NSTimer scheduledTimerWithTimeInterval:1/25.0 target:self selector:@selector(doGyroUpdate) userInfo:nil repeats:YES];
    
    self.azimuth = 0;
    Sonic::createWorld();
    Sonic::setPlayerBearing(0.0);
    audioObj1 = Sonic::addAudioObject("Waterfall.wav", 0, 1, 0);
    
<<<<<<< HEAD
    steeringWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) Label:@"YAW" ZeroPosition:M_PI/2.0 Delegate:self];
    steeringWheel.center = CGPointMake(160, 200);
    [self.view addSubview:steeringWheel];
=======
    azimuthWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) andDelegate:self];
    azimuthWheel.center = CGPointMake(160, 130);
    
    elevationWheel = [[HalfSteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) andDelegate:self];
    elevationWheel.center = CGPointMake(160, 345);
>>>>>>> oldLibrary
    
    [self.view addSubview:azimuthWheel];
    [self.view addSubview:elevationWheel];

    Sonic::startPlaying();
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelDidChangeValue:(NSString *)newValue  :(float)az{
    self.azimuthMain = az;
    self.valueLabel.text = [NSString stringWithFormat:@"%f", RADIANS_TO_DEGREES(azimuthMain)];
    audioObj1->setLocation(sinf(DEGREES_TO_RADIANS(self.azimuthMain)), cosf(DEGREES_TO_RADIANS(self.azimuthMain)), 0);
    NSLog(@"angle: %f", self.azimuthMain);
   Location loc = audioObj1->getLocation();
    NSLog(@"location: %f, %f", loc.getX(), loc.getY());
    // Sonic::setPlayerBearing(180/PI*(-az));
}



/*
-(void) doGyroUpdate {
    double currentYaw = motionManager.deviceMotion.attitude.yaw;
    [azimuthWheel turnWheel:currentYaw];
}
*/


@end
