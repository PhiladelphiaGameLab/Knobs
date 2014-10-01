//
//  RotaryProtocol.h
//  SteerAudio
//
//  Created by Philadelphia Game Lab on 8/5/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RotaryProtocol <NSObject>

- (void) wheelWithName:(NSString *)wheelName didChangeAngleTo:(float)angle;

@end
