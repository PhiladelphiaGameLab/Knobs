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

@synthesize  valueLabel, azimuthMain, audioObj1;

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
    
    self.azimuthMain = 0;
    Sonic::createWorld();
    audioObj1 = Sonic::addAudioObject("Waterfall.wav", 0, 1, 0);
    
    steeringWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) andDelegate:self];
    steeringWheel.center = CGPointMake(160, 200);
    [self.view addSubview:steeringWheel];
    
    Sonic::startPlaying();
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelDidChangeValue:(NSString *)newValue  :(float)az{
    self.azimuthMain = az;
    self.valueLabel.text = [NSString stringWithFormat:@"%f", 180/3.142*(azimuthMain)];
    audioObj1->setLocation(sinf(self.azimuthMain), cosf(self.azimuthMain), 0);
    NSLog(@"AO Location: %f, %f", sinf(self.azimuthMain), cosf(self.azimuthMain));
    // Sonic::setPlayerBearing(180/PI*(-az));
}

/*
-(void) doGyroUpdate {
    double currentYaw = motionManager.deviceMotion.attitude.yaw;
    [steeringWheel turnWheel:currentYaw];
}
*/


@end
