//
//  SteeringWheel.h
//  SteerAudio
//
//  Created by Philadelphia Game Lab on 7/30/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface SteeringWheel : UIControl

@property (weak) id <RotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property CGAffineTransform startTransform;
@property float currentAngle, previousAngle;
@property (nonatomic, strong) UIImageView *wheel;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del;
- (void)turnWheel:(double)angle;
@end
