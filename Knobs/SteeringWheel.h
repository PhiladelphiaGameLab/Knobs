//
//  SteeringWheel.h
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define DEGREES_TO_RADIANS(deg) (deg * (M_PI / 180.0))

// ratios of label dimensions to self dimensions
#define LABEL_WIDTH_RATIO 0.5
#define LABEL_HEIGHT_RATIO 0.2

// distance in px of each text box from center of wheel
#define TEXT_MARGIN 0

@interface SteeringWheel : UIControl

@property (weak) id <RotaryProtocol> delegate;
//@property (nonatomic, strong) UIView *container;
@property CGAffineTransform startTransform;
@property float currentAngle, previousTouchAngle;
@property UIImageView *bg;
@property float zeroPosition;   // Position in degrees along the standard
                                // unit circle to be designated as "zero degrees".
@property NSString *name;

@property UILabel *valueLabel;

- (id)initWithFrame:(CGRect)frame Label:(NSString*)text ZeroPosition:(float)zeroPos Delegate:(id)del;
- (void)turnWheel:(double)angle;
@end