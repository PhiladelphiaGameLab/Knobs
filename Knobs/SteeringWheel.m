//
//  SteeringWheel.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "SteeringWheel.h"
#import <QuartzCore/QuartzCore.h>

@implementation SteeringWheel

@synthesize delegate, /* container,*/ startTransform, currentAngle, previousTouchAngle;

- (id)initWithFrame:(CGRect)frame Label:(NSString*)text ZeroPosition:(float)zeroPos Delegate:(id)del {
    
    if ((self = [super initWithFrame:frame])) {
        self.zeroPosition = zeroPos; // TODO: have this default to zero
        self.delegate = del;
        self.previousTouchAngle = 0;
        self.currentAngle = 0;
        [self drawWheelWithLabel:text];
    }
    return self;
}

- (void) drawWheelWithLabel:(NSString*)text {
    
    //container = [[UIView alloc] initWithFrame:self.frame];
    
    self.bg = [[UIImageView alloc] initWithFrame:self.frame];
    self.bg.image = [UIImage imageNamed:@"blueTracker.png"];
    [self addSubview:self.bg];
    
    float myWidth = self.bounds.size.width;
    float myHeight = self.bounds.size.height;
    CGPoint myCenter = CGPointMake(myWidth/2.0f, myHeight/2.0f);
    
    // Draw text label
    float textRectOriginX = myCenter.x - (LABEL_WIDTH_RATIO/2.0)*myWidth;
    float textRectOriginY = myCenter.y - (LABEL_HEIGHT_RATIO*myWidth) - TEXT_MARGIN;
    
    CGRect textRect = CGRectMake(textRectOriginX, textRectOriginY, LABEL_WIDTH_RATIO*myWidth, LABEL_HEIGHT_RATIO*myHeight);
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:textRect];
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    // Draw value label
    float valueRectOriginY = myCenter.y + TEXT_MARGIN;
    
    CGRect valueRect = CGRectMake(textRectOriginX, valueRectOriginY, LABEL_WIDTH_RATIO*myWidth, LABEL_HEIGHT_RATIO*myHeight);
    
    self.valueLabel = [[UILabel alloc] initWithFrame:valueRect];
    self.valueLabel.text = @"0.0";
    self.valueLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:textLabel];
    [self addSubview:self.valueLabel];
    
    // rotate wheel to starting position
    self.bg.transform = CGAffineTransformRotate(self.bg.transform, -DEGREES_TO_RADIANS(self.zeroPosition));
    
    //container.userInteractionEnabled = NO;
    //[self addSubview:container];
    startTransform = self.bg.transform;
    [self.delegate wheelWithName:@"azimuth" didChangeAngleTo:currentAngle];
}

- (void)turnWheel:(double)angle {
//   self.bg.transform = CGAffineTransformRotate(startTransform, angle);
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
    NSLog(@"currentTouchAngle: %.2f", currentTouchAngle);
    NSLog(@"previousTouchAngle: %.2f", previousTouchAngle);
    NSLog(@"angleDifference: %.2f", angleDifference);
    self.bg.transform = CGAffineTransformRotate(startTransform, -DEGREES_TO_RADIANS(angleDifference));
    
    // convert angle to degrees and scale to range needed by the MIT HRTF library
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
    
    //currentAngle = -currentAngle; // counterclockwise yaw is negative for MIT lib
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", -currentAngle];

    previousTouchAngle = currentTouchAngle;
    startTransform = self.bg.transform;
    
    [self.delegate wheelWithName:@"azimuth" didChangeAngleTo:-currentAngle];
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // TODO: refactor code to avoid repeating all this in multiple functions?
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float currentTouchAngle = RADIANS_TO_DEGREES(atan2(dy,dx));
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousTouchAngle - currentTouchAngle;
    NSLog(@"currentTouchAngle: %.2f", currentTouchAngle);
    self.bg.transform = CGAffineTransformRotate(startTransform, -DEGREES_TO_RADIANS(angleDifference));
   
    // convert angle to degrees and scale to range needed by the MIT HRTF library,
    // where zero degrees is on the y-axis, not the x-axis
    currentAngle += angleDifference;
    if (currentAngle > 180) {
        while (currentAngle > 180) {
            currentAngle -=360;
        }
    } else if (currentAngle <= -180) {
        while (currentAngle <= -180) {
            currentAngle +=360;
        }
    }
    
    //currentAngle = -currentAngle;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", -currentAngle];
    previousTouchAngle = currentAngle;
    [self.delegate wheelWithName:@"azimuth" didChangeAngleTo:-currentAngle];
}


@end
