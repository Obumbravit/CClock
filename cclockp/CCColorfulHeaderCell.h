@import UIKit;
#import <Preferences/PSTableCell.h> 

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;
@end

@interface CCColorfulHeaderCell : PSTableCell
{
    UILabel * titleTrace;
    UIView * title;
    UILabel * subtitle;
}
@end