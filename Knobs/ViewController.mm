//
//  ViewController.m
//  SteerAudio
//
//  Created by Alex Cannon on 9/18/14.
//  Copyright (c) 2014 Philadelphia Game Lab. All rights reserved.
//

#import "ViewController.h"
#include "SteeringWheel.h"

@interface ViewController ()


@end

@implementation ViewController

@synthesize valueLabel, azimuth, elevation, audioObj1;

#define WHEEL_MARGIN_RATIO .1 // ratio of the vertical wheel margin to the height of the view
#define WHEEL_SIZE_RATIO 0.5 // ratio of the wheel diameter to the width of the view
#define SONIC_LABEL_HEIGHT_RATIO 0.05 // ratio of the height of the "sonic" label to the height of the view
#define SONIC_LABEL_WIDTH_RATIO 0.5 // ratio of the width of the "sonic" label to the width of the view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 525, 120, 30)];
//    valueLabel.textAlignment = NSTextAlignmentCenter;
//    valueLabel.textColor = [UIColor lightGrayColor];
//    //valueLabel.backgroundColor = [UIColor lightGrayColor];
//    valueLabel.text = @"FROM SONIC";
//    [self.view addSubview:valueLabel];
    
    // timer = [NSTimer scheduledTimerWithTimeInterval:1/25.0 target:self selector:@selector(doGyroUpdate) userInfo:nil repeats:YES];
    
    self.azimuth = 0;
    Sonic::createWorld();
    Sonic::setPlayerBearing(0.0);
    
    CGSize mySize = self.view.frame.size;
    CGFloat myWidth = mySize.width;
    CGFloat myHeight = mySize.height;
    
    CGFloat wheelSize = WHEEL_SIZE_RATIO*myWidth; // diameter of the wheels
    CGFloat wheelVerticalMargin = WHEEL_MARGIN_RATIO*myHeight;
                                                                    
    CGFloat sonicLabelHeight = LABEL_HEIGHT_RATIO*myHeight;
    CGFloat sonicLabelWidth = LABEL_WIDTH_RATIO*myWidth;
    
    UILabel *sonicLabel = [[UILabel alloc] initWithFrame:CGRectMake((myWidth - sonicLabelWidth)/2.0, (myHeight - sonicLabelHeight)/2.0, sonicLabelWidth, sonicLabelHeight)];
    sonicLabel.text = @"BUILT WITH SONIC";
    sonicLabel.textAlignment = NSTextAlignmentCenter;
    sonicLabel.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:sonicLabel];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"16-44100-beebuzz" ofType:@"wav"];
    std::string soundPathUTF = std::string([soundPath UTF8String]);
    audioObj1 = Sonic::addAudioObject(soundPathUTF, 0, 1, 0);
    
    azimuthWheel = [[SteeringWheel alloc] initWithFrame:CGRectMake(0, 0, wheelSize, wheelSize) Label:@"YAW" ZeroPosition:90 Delegate:self];
    azimuthWheel.center = CGPointMake(.5*myWidth, wheelSize/2.0 + wheelVerticalMargin);
    [self.view addSubview:azimuthWheel];
    
    elevationWheel = [[HalfSteeringWheel alloc] initWithFrame:CGRectMake(0, 0, .5*myWidth, .5*myWidth) Label:@"PITCH" ZeroPosition:0 Delegate:self];
    elevationWheel.center = CGPointMake(.5*myWidth, myHeight - wheelSize/2.0 - wheelVerticalMargin);
    [self.view addSubview:elevationWheel];

    Sonic::startPlaying();
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelWithName:(NSString *)wheelName didChangeAngleTo:(float)angle
{
    if ([wheelName isEqualToString:@"azimuth"]) {
        self.azimuth = angle;
        // TODO: Implement object location setting via polar coords?
        audioObj1->setLocation(cosf(DEGREES_TO_RADIANS(self.elevation))*sinf(DEGREES_TO_RADIANS(self.azimuth)), cosf(DEGREES_TO_RADIANS(self.elevation))*cosf(DEGREES_TO_RADIANS(self.azimuth)), sinf(DEGREES_TO_RADIANS(self.elevation)));
    } else if ([wheelName isEqualToString:@"elevation"]) {
        self.elevation = angle;
        audioObj1->setLocation(cosf(DEGREES_TO_RADIANS(self.elevation))*sinf(DEGREES_TO_RADIANS(self.azimuth)), cosf(DEGREES_TO_RADIANS(self.elevation))*cosf(DEGREES_TO_RADIANS(self.azimuth)), sinf(DEGREES_TO_RADIANS(self.elevation)));
    } else {
        NSLog(@"Invalid wheelname for wheelDidChangeValue: %@", wheelName);
    }
}

CustomAudioUnit* Sonic::cau = nullptr;


@end
