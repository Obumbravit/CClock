#import "CCUIContentModuleContentViewController-Protocol.h"
#import "SBDateTimeOverrideObserver.h"
#import "_UISettingsKeyObserver.h"
#import <UIKit/UIViewController.h>

@class SBFLockScreenDateView, _UILegibilitySettings;
@interface SBUILegibilityLabel
@end

@interface CClockViewController : UIViewController <CCUIContentModuleContentViewController, SBDateTimeOverrideObserver, _UISettingsKeyObserver>
{
	_UILegibilitySettings* _legibilitySettings;
	NSNumber *_timerToken;
}
@property (nonatomic,readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic,readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic,readonly) BOOL providesOwnPlatter;
@property (nonatomic, retain) SBFLockScreenDateView * dateView;
@property (nonatomic, assign) int needsScaling;
@property (nonatomic, assign) bool overrideClip;
@end