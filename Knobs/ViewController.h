//
//  ViewController.h
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"
#include "Sonic.h"
#import <CoreMotion/CoreMotion.h>
#import "SteeringWheel.h"
#import "HalfSteeringWheel.h"

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(degrees) ((degrees) * (M_PI / 180.0))
#endif

@interface ViewController : UIViewController<RotaryProtocol>{
    
    // TODO: Delete some of these?
    NSTimer *timer;
    double originalYaw;
    SteeringWheel *azimuthWheel;
    HalfSteeringWheel *elevationWheel;
}

@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawLabel;
@property UILabel *valueLabel;

@property (atomic) float azimuth;
@property (atomic) float elevation;
@property CustomAudioUnit *customAudioUnit;
@property AudioObj *audioObj1;

@end

