//
//  SteeringWheelViewController.h
//  SteerAudio
//
//  Created by Alex Cannon on 9/16/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "ViewController.h"

@interface SteeringWheelViewController : ViewController

@property (nonatomic, strong) SteeringWheel *wheel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *value;
// @property (weak, nonatomic) IBOutlet UIImageView *wheel;

@end
