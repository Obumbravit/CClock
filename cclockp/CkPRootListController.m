#import <UIKit/UIKit.h>
#import <spawn.h>

#include "CkPRootListController.h"

@implementation CkPRootListController

- (NSArray *)specifiers
{
	if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"CClockp" target:self];
	return _specifiers;
}

- (id)init
{
  	self = [super init];
	UIImageView * titleImage = [[UIImageView alloc] init];
	UIImage * img = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/cclockp.bundle/CClock.png"];
	[titleImage setImage:img];
	titleImage.frame = CGRectMake(titleImage.frame.origin.x, titleImage.frame.origin.y, img.size.width, img.size.height);
	if (self) self.navigationItem.titleView = titleImage;
  	if (self) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
  	return self;
}

- (void)apply
{
	[self.view endEditing:YES];
	pid_t pid;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/sbreload"])
	{
		const char* args[] = {"sbreload", NULL};
		posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL); 
	} 
	else
	{
		const char* args[] = {"killall", "-9", "backboardd", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
	};
}

- (void)twitter
{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) url = [NSURL URLWithString:@"tweetbot:///user_profile/Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) url = [NSURL URLWithString:@"twitterrific:///profile?screen_name=Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) url = [NSURL URLWithString:@"tweetings:///user?screen_name=Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) url = [NSURL URLWithString:@"twitter://user?screen_name=Obumbravit"];
	else url = [NSURL URLWithString:@"https://mobile.twitter.com/Obumbravit"];
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)kofi
{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"kofi:"]]) url = [NSURL URLWithString:@"https://ko-fi.com/obumbravit"];
	else url = [NSURL URLWithString:@"https://ko-fi.com/obumbravit"];
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end