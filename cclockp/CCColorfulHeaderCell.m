#include "CCColorfulHeaderCell.h"

@implementation CCColorfulHeaderCell

- (id)initWithSpecifier:(PSSpecifier *)specifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
	if (self)
	{
        CGFloat titleHeight = 50;
        CGFloat subtitleHeight = 25;

		titleTrace = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, titleHeight)];
		titleTrace.numberOfLines = 1;
		titleTrace.font = [UIFont systemFontOfSize:45];
		titleTrace.text = @"CClock";
		titleTrace.textAlignment = NSTextAlignmentCenter;

        title = [[UIView alloc] initWithFrame: CGRectMake(0, (125 - (titleHeight + subtitleHeight)) / 2, UIScreen.mainScreen.bounds.size.width, titleHeight)];
        CAGradientLayer * gradient = [CAGradientLayer layer];
        gradient.frame = title.bounds;
        gradient.colors = @[(id)[UIColor colorWithRed: 0.42 green: 0.87 blue: 1.00 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.00 green: 0.00 blue: 0.37 alpha: 1.00].CGColor];
        [title.layer insertSublayer:gradient atIndex: 0];
        title.maskView = titleTrace;
        [self addSubview: title];

		subtitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 125 - (125 - (titleHeight + subtitleHeight)), UIScreen.mainScreen.bounds.size.width, subtitleHeight)];
		subtitle.numberOfLines = 1;
		subtitle.font = [UIFont systemFontOfSize: 15];
		subtitle.text = @"A true Control Center clock.";
		subtitle.textColor = [UIColor grayColor];
		subtitle.textAlignment = NSTextAlignmentCenter;
		[self addSubview: subtitle];
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 0;
    [super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width
{
	return 125.f;
}

@end