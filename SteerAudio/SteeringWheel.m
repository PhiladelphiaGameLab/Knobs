//
//  SteeringWheel.m
//  SteerAudio
//
//  Created by Philadelphia Game Lab on 7/30/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "SteeringWheel.h"
#import <QuartzCore/QuartzCore.h>


@interface SteeringWheel()
- (void)drawWheel;
@end

static float existingAngle;

@implementation SteeringWheel

@synthesize  delegate, container, startTransform, currentAngle, existingAngle;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del {
    
    if ((self = [super initWithFrame:frame])) {
        self.delegate = del;
        self.existingAngle = 0;
        self.currentAngle = 0;
        [self drawWheel];
    }
    return self;
}

- (void) drawWheel {
    
    container = [[UIView alloc] initWithFrame:self.frame];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
    bg.image = [UIImage imageNamed:@"blueTracker0.png"];
    [container addSubview:bg];
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    // startTransform = container.transform;
     [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
}


- (void)turnWheel:(double)angle {
//    container.transform = CGAffineTransformRotate(startTransform, angle);
//    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)angle)] :angle];
}

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
    
    currentAngle = RADIANS_TO_DEGREES(ang) + 90;
    //currentAngle = existingAngle - RADIANS_TO_DEGREES(angleDifference);
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180) {
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    existingAngle = currentAngle;
    NSLog(@"Current angle: %f", currentAngle);
    
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngle)] :currentAngle];
    
}


@end
