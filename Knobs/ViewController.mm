//
//  ViewController.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "ViewController.h"
#include "SteeringWheel.h"

@interface ViewController ()


@end

@implementation ViewController

@synthesize valueLabel, azimuth, elevation, audioObj1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 525, 120, 30)];
//    valueLabel.textAlignment = NSTextAlignmentCenter;
//    valueLabel.textColor = [UIColor lightGrayColor];
//    //valueLabel.backgroundColor = [UIColor lightGrayColor];
//    valueLabel.text = @"FROM SONIC";
//    [self.view addSubview:valueLabel];
    
    // timer = [NSTimer scheduledTimerWithTimeInterval:1/25.0 target:self selector:@selector(doGyroUpdate) userInfo:nil repeats:YES];
    
    self.azimuth = 0;
    Sonic::createWorld();
    Sonic::setPlayerBearing(0.0);
    audioObj1 = Sonic::addAudioObject("input1mono.wav", 0, 1, 0);
    
    azimuthWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) Label:@"YAW" ZeroPosition:M_PI/2.0 Delegate:self];
    azimuthWheel.center = CGPointMake(160, 130);
    [self.view addSubview:azimuthWheel];
    
    elevationWheel = [[HalfSteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) Label:@"PITCH" ZeroPosition:0.0 Delegate:self];
    elevationWheel.center = CGPointMake(160, 350);
    [self.view addSubview:elevationWheel];

    Sonic::startPlaying();
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelDidChangeValue:(NSString *)newValue  :(float)az{
    self.azimuth = az;
    self.valueLabel.text = [NSString stringWithFormat:@"%f", RADIANS_TO_DEGREES(azimuth)];
    audioObj1->setLocation(sinf(DEGREES_TO_RADIANS(self.azimuth)), cosf(DEGREES_TO_RADIANS(self.azimuth)), 0);
    NSLog(@"angle: %f", self.azimuth);
   Location loc = audioObj1->getLocation();
    NSLog(@"location: %f, %f", loc.getX(), loc.getY());
    // Sonic::setPlayerBearing(180/PI*(-az));
}

CustomAudioUnit* Sonic::cau = nullptr;


@end
