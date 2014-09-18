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
//@property (nonatomic, strong) UIView *container;
@property CGAffineTransform startTransform;
@property float currentAngle, previousAngle;
@property UIImageView *bg;
@property float zeroPosition;   // Position in degrees along the standard
                                // unit circle to be designated as "zero degrees".

@property UILabel *valueLabel;

- (id)initWithFrame:(CGRect)frame Label:(NSString*)text ZeroPosition:(float)zeroPos Delegate:(id)del;
- (void)turnWheel:(double)angle;
@end
