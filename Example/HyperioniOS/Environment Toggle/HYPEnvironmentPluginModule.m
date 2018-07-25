//
//  HYPSlowAnimationsPluginModule.m
//  Pods
//
//  Created by Christopher Mays on 6/19/17.
//
//

#import "HYPEnvironmentPluginModule.h"
#import "HYPPluginMenuItem.h"
#import "HYPEnvironmentPluginMenuItem.h"

@interface HYPEnvironmentPluginModule () <HYPPluginMenuItemDelegate>
@property (nonatomic) BOOL *environmentsVisible;
@end

@implementation HYPEnvironmentPluginModule
@synthesize pluginMenuItem = _pluginMenuItem;

-(UIView *)pluginMenuItem
{
    if (_pluginMenuItem)
    {
        return _pluginMenuItem;
    }

    HYPEnvironmentPluginMenuItem *pluginView = [[HYPEnvironmentPluginMenuItem alloc] init];
    [pluginView bindWithTitle:@"Environment Toggle" image:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"timer" ofType:@"png"]]];

    pluginView.delegate = self;

    _pluginMenuItem = pluginView;

    bool slowAnimationsOn = self.extension.attachedWindow.layer.speed != 1.0;

    [_pluginMenuItem setSelected:slowAnimationsOn animated:false];

    return  _pluginMenuItem;
}

-(void)pluginMenuItemSelected:(UIView *)pluginView
{
    [(HYPPluginMenuItem *)_pluginMenuItem setSelected:!_pluginMenuItem.isSelected animated:true];
}

@end
