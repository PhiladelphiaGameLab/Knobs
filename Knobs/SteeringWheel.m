//
//  SteeringWheel.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "SteeringWheel.h"
#import <QuartzCore/QuartzCore.h>

@interface SteeringWheel()
- (void)drawWheel;
@end

@implementation SteeringWheel

@synthesize delegate, /* container,*/ startTransform, currentAngleRads, previousAngleRads;

- (id)initWithFrame:(CGRect)frame Label:(NSString*)text ZeroPosition:(float)zeroPos Delegate:(id)del {
    
    if ((self = [super initWithFrame:frame])) {
        self.zeroPosition = zeroPos; // TODO: have this default to zero
        self.delegate = del;
        self.previousAngleRads = 0;
        self.currentAngleRads = 0;
        [self drawWheelWithLabel:text];
    }
    return self;
}

- (void) drawWheelWithLabel:(NSString*)text {
    
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
    NSLog(@"%f", -DEGREES_TO_RADIANS(self.zeroPosition));
    
    //container.userInteractionEnabled = NO;
    //[self addSubview:container];
    startTransform = self.bg.transform;
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngleRads)] :currentAngleRads];
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
    previousAngleRads = atan2(dy,dx);
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float angle = atan2(dy,dx);
    
    // rotate wheel by the difference between the current and previous angles
    float angleDifference = previousAngleRads - angle;
    self.bg.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    // convert angle to degrees and scale to range needed by the MIT HRTF library,
    currentAngleRads = RADIANS_TO_DEGREES(angle) - self.zeroPosition;

    if (currentAngleRads > 180) {
        while (currentAngleRads > 180) {
            currentAngleRads -=360;
        }
    } else if (currentAngleRads <= -180){
        while (currentAngleRads <= -180) {
            currentAngleRads +=360;
        }
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", currentAngleRads];

    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngleRads)] :currentAngleRads];
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // calculate new angle
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = touchPoint.x - center.x;
    float dy = touchPoint.y - center.y;
    float angle = atan2(dy,dx);
    
    // rotate wheel by the difference between the current and previous angles
    NSLog(@"Previous Angle: %f", previousAngleRads);
    float angleDifference = previousAngleRads - angle;
    self.bg.transform = CGAffineTransformRotate(startTransform, -angleDifference);
   
    // convert angle to degrees and scale to range needed by the MIT HRTF library,
    // where zero degrees is on the y-axis, not the x-axis
    currentAngleRads = RADIANS_TO_DEGREES(angle) - self.zeroPosition;
    if (currentAngleRads > 180) {
        while (currentAngleRads > 180) {
            currentAngleRads -=360;
        }
    } else if (currentAngleRads <= -180) {
        while (currentAngleRads <= -180) {
            currentAngleRads +=360;
        }
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", currentAngleRads];
    previousAngleRads = currentAngleRads;
    [self.delegate wheelDidChangeValue: [NSString stringWithFormat:@"%i", ((int)currentAngleRads)] :currentAngleRads];
}


@end
