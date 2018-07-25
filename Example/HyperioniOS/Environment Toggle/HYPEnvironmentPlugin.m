//
//  HYPAttributesInspectorModule.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPEnvironmentPlugin.h"
#import "HYPEnvironmentPluginModule.h"
#import "HYPEnvironmentConfigConstants.h"

@implementation HYPEnvironmentPlugin

+(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    
    // Check for environment plist
    NSString *environmentPlistPath = [[NSBundle mainBundle] pathForResource:@"HyperionEnvironmentToggle" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:environmentPlistPath];
    
    if ([[configuration objectForKey:HYPEnvironmentConfigOptions] isKindOfClass:[NSArray class]])
    {
        NSArray *environments = [configuration objectForKey:HYPEnvironmentConfigOptions];
        NSLog(@"Environments from plist = %@", environments);
    }
    
    return [[HYPEnvironmentPluginModule alloc] initWithExtension:pluginExtension];
}

+ (NSString *)pluginVersion
{
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
