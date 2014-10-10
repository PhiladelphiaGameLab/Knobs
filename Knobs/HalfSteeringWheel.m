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

@synthesize delegate, /* container,*/ startTransform, currentAngle, previousAngle, previousTouchAngle;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float dist = sqrt(dx*dx + dy*dy);
    
    if (dist < 40 || dist > 100)
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    startTransform = self.bg.transform;
    previousTouchAngle = RADIANS_TO_DEGREES(atan2(dy,dx));
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float currentTouchAngle = RADIANS_TO_DEGREES(atan2(dy,dx));
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousTouchAngle - currentTouchAngle;
    previousAngle = currentAngle;
    currentAngle += angleDifference;
    
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180){
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // only rotate up to 90 or down to -90
    if (currentAngle > 90) {
        angleDifference = 90 - previousAngle; // amount needed to rotate to 90 degrees
        currentAngle = 90.00;
    } else if (currentAngle < -40) {
        angleDifference = -40 - previousAngle; // amount needed to rotate to -90 degrees
        currentAngle = -40.00;
    }
    
    self.bg.transform = CGAffineTransformRotate(startTransform, -DEGREES_TO_RADIANS(angleDifference));

    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", currentAngle];
    
    previousTouchAngle = currentTouchAngle; // why does this break things?
    startTransform = self.bg.transform;
    
    [self.delegate wheelWithName:@"elevation" didChangeAngleTo:currentAngle];
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float currentTouchAngle = RADIANS_TO_DEGREES(atan2(dy,dx));
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousTouchAngle - currentTouchAngle;
    previousAngle = currentAngle;
    currentAngle += angleDifference;
    
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180){
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // only rotate up to 90 or down to -90
    if (currentAngle > 90) {
        angleDifference = 90 - previousAngle; // amount needed to rotate to 90 degrees
        currentAngle = 90.00;
    } else if (currentAngle < -40) {
        angleDifference = -40 - previousAngle; // amount needed to rotate to -90 degrees
        currentAngle = -40.00;
    }
    
    self.bg.transform = CGAffineTransformRotate(startTransform, -DEGREES_TO_RADIANS(angleDifference));
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", currentAngle];
    previousTouchAngle = currentAngle;
    [self.delegate wheelWithName:@"elevation" didChangeAngleTo:currentAngle];
}

@end