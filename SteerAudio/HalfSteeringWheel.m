//
//  HalfSteeringWheel.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/15/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "HalfSteeringWheel.h"

@implementation HalfSteeringWheel

@synthesize  delegate, container, startTransform, currentAngle, existingAngle;

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
    
    startTransform = container.transform;
    existingAngle = atan2(dy,dx);
    
    return YES;
    
}


- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float ang = atan2(dy,dx);
    
    float angleDifference = existingAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    currentAngle = existingAngle - RADIANS_TO_DEGREES(angleDifference);
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    }else if (currentAngle <= -180){
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // for HalfSteeringWheel we only want to accept values in the range [-90, 90]
        if (currentAngle > 90) {
            currentAngle = 90;
        } else if (currentAngle < -90) {
            currentAngle = -90;
        }
    existingAngle = currentAngle;

    
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
    
    return YES;
    
}


- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float ang = atan2(dy,dx);
    
    float angleDifference = existingAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    currentAngle = existingAngle - RADIANS_TO_DEGREES(angleDifference);
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180){
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    // for HalfSteeringWheel we only want to accept values in the range [-90, 90]
    if (currentAngle > 90) {
        currentAngle = 90;
    } else if (currentAngle < -90) {
        currentAngle = -90;
    }
    existingAngle = currentAngle;
    
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
    
}


@end
