//
//  HYPSlowAnimationsPluginMenuItem.h
//  SlowAnimations
//
//  Created by Chris Mays on 11/27/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPPluginMenuItem.h"

typedef enum : NSUInteger {
    HYPENVIRONMENT_PROD,
    HYPENVIRONMENT_STAGING,
    HYPENVIRONMENT_DEV,
} HYPEnvironment;

@interface HYPEnvironmentPluginMenuItem : HYPPluginMenuItem

@end
