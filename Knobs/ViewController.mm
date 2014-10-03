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
    audioObj1 = Sonic::addAudioObject("16-44100-pianoriff.wav", 0, 1, 0);
    
    azimuthWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) Label:@"YAW" ZeroPosition:90 Delegate:self];
    azimuthWheel.center = CGPointMake(160, 130);
    [self.view addSubview:azimuthWheel];
    
    elevationWheel = [[HalfSteeringWheel alloc] initWithFrame:CGRectMake(0, 0, 150, 150) Label:@"PITCH" ZeroPosition:0 Delegate:self];
    elevationWheel.center = CGPointMake(160, 350);
    [self.view addSubview:elevationWheel];

    Sonic::startPlaying();
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelWithName:(NSString *)wheelName didChangeAngleTo:(float)angle
{
    if ([wheelName isEqualToString:@"azimuth"]) {
        self.azimuth = angle;
        // TODO: Implement object location setting via polar coords?
        audioObj1->setLocation(cosf(DEGREES_TO_RADIANS(self.elevation))*sinf(DEGREES_TO_RADIANS(self.azimuth)), cosf(DEGREES_TO_RADIANS(self.elevation))*cosf(DEGREES_TO_RADIANS(self.azimuth)), sinf(DEGREES_TO_RADIANS(self.elevation)));
    } else if ([wheelName isEqualToString:@"elevation"]) {
        self.elevation = angle;
        audioObj1->setLocation(cosf(DEGREES_TO_RADIANS(self.elevation))*sinf(DEGREES_TO_RADIANS(self.azimuth)), cosf(DEGREES_TO_RADIANS(self.elevation))*cosf(DEGREES_TO_RADIANS(self.azimuth)), sinf(DEGREES_TO_RADIANS(self.elevation)));
    } else {
        NSLog(@"Invalid wheelname for wheelDidChangeValue: %@", wheelName);
    }
}

CustomAudioUnit* Sonic::cau = nullptr;


@end
