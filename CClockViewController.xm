#import "CClockViewController.h"
#import "SBDateTimeController.h"
#import "SBFLockScreenDateView.h"
#import "SBFLegibilityDomain.h"
#import "SBPreciseClockTimer.h"
#import "SBPrototypeController.h"
#import "SBUIPreciseClockTimer.h"
#import "_UILegibilitySettings.h"

#import <algorithm>
#import <vector>

@implementation CClockViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dateView = nil;
		_legibilitySettings = nil;
		_timerToken = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createDateViewIfNeeded
{
	if (self.dateView == nil)
    {
		self.dateView = [[%c(SBFLockScreenDateView) alloc] initWithFrame:CGRectZero];
		[self.dateView setUserInteractionEnabled:NO];
		[self.dateView setLegibilitySettings:_legibilitySettings];
		/*if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Jellyfish.dylib"])
        {
			[self.dateView setAlignmentPercent:1.0];
		}
        else
        {
			[self.dateView setAlignmentPercent:0.0];
		} 1.1*/
		if (self.needsScaling == 1 || self.needsScaling == 2) self.dateView.useCompactDateFormat = true;
		if (self.needsScaling == 2)
		{
			for (UILabel * timeLabel in self.dateView.subviews)
			{
				if ([timeLabel isKindOfClass:[%c(SBUILegibilityLabel) class]])
				{
					timeLabel.adjustsFontSizeToFitWidth = true;
				}
			}
		}
		if (self.needsScaling == 3) self.dateView.transform = CGAffineTransformScale(self.dateView.transform, 0.5, 0.5);
		self.dateView.clipsToBounds = (self.overrideClip) ? false : true;
		[self.view addSubview:self.dateView];
	}
}

- (void)updateTimeNow
{
	NSDate *overrideDate = [[%c(SBDateTimeController) sharedInstance] overrideDate];
	if (overrideDate != nil)
    {
		[self.dateView setDate:overrideDate];
	}
    else
    {
		Class PreciseClockTimer = %c(SBUIPreciseClockTimer) ?: %c(SBPreciseClockTimer);
		[self.dateView setDate:[PreciseClockTimer now]];
	}
}

- (void)_updateFormat
{
	[self.dateView updateFormat];
	[self updateTimeNow];
}

-(void)_updateLegibilityStrength
{
	LegibilitySettings *settings = nil;
	if (%c(SBFLegibilityDomain))
    {
		settings = [%c(SBFLegibilityDomain) rootSettings];
	}
    else
    {
		settings = [[[%c(SBPrototypeController) sharedInstance] rootSettings] legibilitySettings];
	}
	CGFloat style = [_legibilitySettings style];
	[self.dateView setTimeLegibilityStrength:[settings timeStrengthForStyle:style]];
	[self.dateView setSubtitleLegibilityStrength:[settings dateStrengthForStyle:style]];
}

- (void)controller:(id)arg1 didChangeOverrideDateFromDate:(id)arg2
{
	[self _updateFormat];
}

- (void)settings:(id)arg1 changedValueForKey:(id)arg2
{
	Class LegibilitySettings = %c(SBLegibilitySettings) ?: %c(SBFLegibilitySettings);
	if ([arg1 isMemberOfClass:LegibilitySettings])
    {
		[self _updateLegibilityStrength];
	}
}

- (void)_addObservers
{
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(_updateFormat) name:@"BSDateTimeCacheChangedNotification" object:nil];
	[defaultCenter addObserver:self selector:@selector(updateTimeNow) name:UIContentSizeCategoryDidChangeNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(updateTimeNow) name:@"UIAccessibilityLargeTextChangedNotification" object:nil];

	[[%c(SBDateTimeController) sharedInstance] addObserver:self];
	if (%c(SBFLegibilityDomain))
    {
		[[%c(SBFLegibilityDomain) rootSettings] addKeyObserver:self];
	}
    else
    {
		[[[[%c(SBPrototypeController) sharedInstance] rootSettings] legibilitySettings] addKeyObserverIfPrototyping:self];
	}
}

- (void)_removeObservers
{
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter removeObserver:self name:@"BSDateTimeCacheChangedNotification" object:nil];
	[defaultCenter removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
	[defaultCenter removeObserver:self name:@"UIAccessibilityLargeTextChangedNotification" object:nil];

	[[%c(SBDateTimeController) sharedInstance] removeObserver:self];
	if (%c(SBFLegibilityDomain))
    {
		[[%c(SBFLegibilityDomain) rootSettings] removeKeyObserver:self];
	}
    else
    {
		[[[[%c(SBPrototypeController) sharedInstance] rootSettings] legibilitySettings] removeKeyObserver:self];
	}
}

- (void)loadView
{
	[super loadView];

	[self createDateViewIfNeeded];

	[self _updateLegibilityStrength];
	[self updateTimeNow];
	[self _addObservers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateTimeNow];

	if (_timerToken == nil)
    {
		Class PreciseClockTimer = %c(SBUIPreciseClockTimer) ?: %c(SBPreciseClockTimer);
		_timerToken = [[PreciseClockTimer sharedInstance] startMinuteUpdatesWithHandler:^{
			[self updateTimeNow];
		}];
	}

    _preferredExpandedContentWidth = self.view.frame.size.width;
    _preferredExpandedContentHeight = self.view.frame.size.height;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	if (_timerToken != nil)
    {
		Class PreciseClockTimer = %c(SBUIPreciseClockTimer) ?: %c(SBPreciseClockTimer);
		[[PreciseClockTimer sharedInstance] stopMinuteUpdatesForToken:_timerToken];
		_timerToken = nil;
	}
}

- (BOOL)_canShowWhileLocked
{
	return YES;
}

- (void)dealloc
{
	[self _removeObservers];

	if (_timerToken != nil)
    {
		Class PreciseClockTimer = %c(SBUIPreciseClockTimer) ?: %c(SBPreciseClockTimer);
		[[PreciseClockTimer sharedInstance] stopMinuteUpdatesForToken:_timerToken];
		_timerToken = nil;
	}

	[self.dateView removeFromSuperview];
	self.dateView = nil;
}

@end

%hook SBFLockScreenDateView

- (void)layoutSubviews
{
	%orig();

	if (self.superview != nil && [self.superview.superview isKindOfClass:%c(CCUIContentModuleContentContainerView)])
    {
		if ([self.subviews containsObject:self.subviews[0]])
		{
			CGFloat offset = 0;
			if ([self.subviews containsObject:self.subviews[1]])
			{
				if (self.subviews[0].frame.size.height && self.subviews[1].frame.size.height)
				{
					CGFloat offsetTest = (self.superview.frame.size.height - (self.subviews[0].frame.size.height + self.subviews[1].frame.size.height)) / 2;
					offset = (offsetTest >= 0) ? offsetTest : 0;
				}
			}
			self.frame = CGRectMake(0, offset, self.superview.frame.size.width, self.superview.frame.size.height - (offset * 2));
			self.restingFrame = self.frame;
			if (self.subviews[0].frame.size.width > self.frame.size.width) self.subviews[0].frame = CGRectMake(0, self.subviews[0].frame.origin.y, self.frame.size.width, self.subviews[0].frame.size.height);
		}
	}
}

%end