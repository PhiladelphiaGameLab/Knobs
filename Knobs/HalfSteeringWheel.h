//
//  HalfSteeringWheel.h
//  SteerAudio
//
//  Created by Alex Cannon on 9/15/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "SteeringWheel.h"

@interface HalfSteeringWheel : SteeringWheel

// needed to calculate how far to rotate to 90 or -90 degrees but not past
@property float previousAngle;

@end
