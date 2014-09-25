//
//  ViewController.h
//  SteerAudio
//
//  Created by Philadelphia Game Lab on 7/30/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"
#include "SonicLibrary/Sonic.h"
#import <CoreMotion/CoreMotion.h>
#import "SteeringWheel.h"
#import "HalfSteeringWheel.h"

// TODO: replace with M_PI
#define PI 3.14159
#define DEGREES_TO_RADIANS(degrees) ((degrees) * (PI / 180.0))

@interface ViewController : UIViewController<RotaryProtocol>{
    
    // TODO: Delete some of these?
    CMMotionManager *motionManager;
    NSTimer *timer;
    double originalYaw;
    SteeringWheel *azimuthWheel;
    HalfSteeringWheel *elevationWheel;
}

@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawLabel;
@property (weak, nonatomic) UILabel *valueLabel;

@property (atomic) float azimuth;
@property (atomic) float elevation;
@property CustomAudioUnit *customAudioUnit;
@property AudioObj *audioObj1;

@end

