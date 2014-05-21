#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences//PSTableCell.h>

//#import <Preferences/Preferences.h>

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController
{
    NSArray *_specifiers;
}

- (void)loadView;
- (id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2;
@end

__attribute__((visibility("hidden")))
@interface PTListController : PSListController
- (id)specifiers;
@end

@implementation PTListController

- (id)specifiers
{
	if(_specifiers == nil)
		_specifiers = [[self loadSpecifiersFromPlistName:@"Percentext" target:self] retain];

	return _specifiers;
}

- (void)respring:(id)specifier
{
    system("killall SpringBoard");
}

- (void)loadView
{
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)] autorelease];
}

- (void)launchTwitter:(id)specifier
{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/magn2o"]];
	else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/magn2o/"]];
}

@end
