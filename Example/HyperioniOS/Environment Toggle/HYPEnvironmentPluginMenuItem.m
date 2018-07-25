//
//  HYPSlowAnimationsPluginMenuItem.m
//  SlowAnimations
//
//  Created by Chris Mays on 11/27/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPEnvironmentPluginMenuItem.h"
#import "HyperionManager.h"

@interface HYPEnvironmentPluginMenuItem()
@property (nonatomic) UIButton *prodEnvironment;
@property (nonatomic) UIButton *stagingEnvironment;
@property (nonatomic) UIButton *devEnvironment;
@property (nonatomic) UIStackView *stackview;
@property (nonatomic) NSArray *buttonArray;

@end
@implementation HYPEnvironmentPluginMenuItem

-(instancetype)init
{
    self = [super init];
    
    self.height = 150;
    
    _stackview = [[UIStackView alloc] init];
    _stackview.spacing = 11;
    
    _prodEnvironment = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_prodEnvironment setTitle:@"Prod" forState:UIControlStateNormal];
    [_prodEnvironment setTag:10];
    
    _stagingEnvironment = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_stagingEnvironment setTitle:@"QA" forState:UIControlStateNormal];
    [_stagingEnvironment setTag:11];
    
    _devEnvironment = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_devEnvironment setTitle:@"Dev" forState:UIControlStateNormal];
    [_devEnvironment setTag:12];
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:_prodEnvironment, _stagingEnvironment, _devEnvironment, nil];
    self.buttonArray = buttons;
    
    for (UIButton *button in buttons) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.widthAnchor constraintEqualToConstant:50].active = true;
        [button.heightAnchor constraintEqualToConstant:50].active = true;
        button.layer.cornerRadius = 25;
        button.translatesAutoresizingMaskIntoConstraints = false;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_stackview addArrangedSubview:_prodEnvironment];
    [_stackview addArrangedSubview:_stagingEnvironment];
    [_stackview addArrangedSubview:_devEnvironment];
    
    [self addSubview:_stackview];
    
    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    [_stackview.leadingAnchor constraintEqualToAnchor:self.pluginImageView.leadingAnchor].active = true;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:_stackview.trailingAnchor].active = true;
    [_stackview.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor].active = true;
    [_stackview.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor].active = true;
    
    [self updateButtons];

    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    CATransform3D yTranslation = CATransform3DTranslate(CATransform3DIdentity, 0, -45, 0);
    
    for (UIButton *button in _buttonArray) {
        button.alpha = selected ? 0 : 1;
        button.layer.transform = selected ? yTranslation : CATransform3DIdentity;
    }

    [UIView animateKeyframesWithDuration:animated ? 0.4 : 0.0 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState & UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        double factor = 0.27;
        double startTime = 0.0;
        for (UIView *subview in _stackview.arrangedSubviews) {
            [UIView addKeyframeWithRelativeStartTime:startTime relativeDuration:0.33 animations:^{
                subview.layer.transform = selected ? CATransform3DIdentity : yTranslation;
                subview.alpha = selected ? 1.0 : 0.0;
            }];
            startTime += factor;
        }
    } completion:nil];
}

-(void)environmentSelected: (HYPEnvironment)environment
{
    NSString *environmentString;
    switch (environment) {
        case HYPENVIRONMENT_PROD:
            environmentString = @"production";
            break;
        case HYPENVIRONMENT_STAGING:
            environmentString = @"staging";
            break;
        case HYPENVIRONMENT_DEV:
            environmentString = @"development";
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:environmentString forKey:@"HYP_ENVIRONMENT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNotification *notification = [NSNotification notificationWithName:@"HYPENVIRONMENTCHANGED"
                                                                 object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    #if DEBUG
        NSLog(@"Hyperion Environment selected: %@", environmentString);
    #endif
}

-(HYPEnvironment)getSelectedEnvironment
{
    NSString *selectedEnvironment = [[NSUserDefaults standardUserDefaults] stringForKey:@"HYP_ENVIRONMENT"];
    if ([selectedEnvironment  isEqual: @"production"]) {
        return HYPENVIRONMENT_PROD;
    } else if ([selectedEnvironment  isEqual: @"development"]) {
        return HYPENVIRONMENT_DEV;
    } else {
        // Use staging by default
        return HYPENVIRONMENT_STAGING;
    }
}

-(void)buttonTapped: (UIButton*)sender
{
    switch (sender.tag) {
        case 10:
            [self environmentSelected:HYPENVIRONMENT_PROD];
            break;
        case 11:
            [self environmentSelected:HYPENVIRONMENT_STAGING];
            break;
        case 12:
            [self environmentSelected:HYPENVIRONMENT_DEV];
            break;
        default:
            break;
    }
    
    [self updateButtons];
}

-(void)selectButton: (UIButton*)button selected:(BOOL)selected
{
    if (selected) {
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)updateButtons
{
    // Check which button is selected and deselect others
    HYPEnvironment environment = [self getSelectedEnvironment];
    switch (environment) {
        case HYPENVIRONMENT_PROD:
            [self selectButton:_prodEnvironment selected:true];
            [self selectButton:_stagingEnvironment selected:false];
            [self selectButton:_devEnvironment selected:false];
            break;
        case HYPENVIRONMENT_STAGING:
            [self selectButton:_prodEnvironment selected:false];
            [self selectButton:_stagingEnvironment selected:true];
            [self selectButton:_devEnvironment selected:false];
            break;
        case HYPENVIRONMENT_DEV:
            [self selectButton:_prodEnvironment selected:false];
            [self selectButton:_stagingEnvironment selected:false];
            [self selectButton:_devEnvironment selected:true];
            break;
    }
}

@end
