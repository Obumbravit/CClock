#import "CCUIContentModule-Protocol.h"
#import "ControlCenterUI-Structs.h"
#import "CClockViewController.h"

@interface NSUserDefaults (CClock)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface CClock : NSObject <CCUIContentModule>
@property (nonatomic, readonly) UIViewController * backgroundViewController;
@property (nonatomic, readonly) CClockViewController * contentViewController;
@end