//
//  HYPSlowAnimationsPluginModule.h
//  Pods
//
//  Created by Christopher Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

@interface HYPEnvironmentPluginModule : HYPPluginModule

@property (nonatomic, readonly, nonnull) id<HYPPluginExtension> extension;

@end
