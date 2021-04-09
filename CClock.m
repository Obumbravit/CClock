#import "CClock.h"
#import <objc/runtime.h>

@implementation CClock

- (id)init
{
  if ((self = [super init]))
  {
    _contentViewController = [[CClockViewController alloc] init];
  }
  return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation
{
  int ModuleSize = [[[[NSUserDefaults alloc] initWithSuiteName:@"com.obumbravit.cclock"] objectForKey:@"MSize"] intValue];

  NSNumber * overrideSwitchValuee = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"overrideSwitch" inDomain:@"com.obumbravit.cclock"];
  self.contentViewController.overrideClip = (overrideSwitchValuee) ? [overrideSwitchValuee boolValue] : NO;

  if (ModuleSize == 0)
  {
    self.contentViewController.needsScaling = 0;
    return (CCUILayoutSize){4, 2};
  }
  else if (ModuleSize == 1)
  {
    self.contentViewController.needsScaling = 1;
    return (CCUILayoutSize){3, 2};
  }
  else if (ModuleSize == 2)
  {
    self.contentViewController.needsScaling = 2;
    return (CCUILayoutSize){2, 2};
  }
  else if (ModuleSize == 3)
  {
    self.contentViewController.needsScaling = 3;
    return (CCUILayoutSize){2, 1};
  }
  else
  {
    self.contentViewController.needsScaling = 0;
    return (CCUILayoutSize){4, 2};
  }
}

@end