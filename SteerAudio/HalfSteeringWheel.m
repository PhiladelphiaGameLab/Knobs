//
//  HalfSteeringWheel.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/15/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "HalfSteeringWheel.h"

// TODO: Can we avoid redefining PI and DEGREES_TO_RADIANS here?
#ifndef PI
#define PI 3.14159
#endif

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(degrees) ((degrees) * (PI / 180.0))
#endif

@implementation HalfSteeringWheel

@synthesize  delegate, /* container,*/ startTransform, currentAngle, previousAngle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float dist = sqrt(dx*dx + dy*dy);
    
    if (dist < 40 || dist > 100)
    {
        // forcing a tap` to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    startTransform = self.bg.transform;
    previousAngle = atan2(dy,dx);
    
    return YES;
}
*/

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float ang = atan2(dy,dx);
    
    // convert angle to degrees and scale to range needed by the MIT HRTF library,
    // where zero degrees is on the y-axis, not the x-axis
    currentAngle = RADIANS_TO_DEGREES(angle) + 90;
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -= 360;
        }
    } else if (currentAngle <= -180){
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // only accept angles in the range [-90, 90]
    if (currentAngle > 90) {
        currentAngle = 90;
    } else if (currentAngle < -90) {
        currentAngle = -90;
    }
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousAngle - DEGREES_TO_RADIANS(currentAngle);
    self.bg.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
    return YES;
}

/*
- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float ang = atan2(dy,dx);
    
    float angleDifference = previousAngle - ang;
    self.bg.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    // convert angle to degrees and scale to range needed by the MIT HRTF library,
    // where zero degrees is on the y-axis, not the x-axis
    currentAngle = RADIANS_TO_DEGREES(angle) + 90;
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180) {
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // only accept angles in the range [-90, 90]
    if (currentAngle > 90) {
        currentAngle = 90;
    } else if (currentAngle < -90) {
        currentAngle = -90;
    }
    
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousAngle - DEGREES_TO_RADIANS(currentAngle);
    
    NSLog(@"Rotating half steering wheel %f radians...", angleDifference);
    self.bg.transform = CGAffineTransformRotate(startTransform, -angleDifference);

    // previousAngle = currentAngle;
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
}
*/

@end
