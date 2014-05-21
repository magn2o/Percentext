static BOOL isEnabled = YES;
static BOOL shouldShowPercentSymbol = NO;

@interface UIStatusBarItemView : UIView
- (id)imageWithText:(id)arg1;
@end

@interface UIStatusBarBatteryPercentItemView : UIStatusBarItemView @end

%hook UIStatusBarBatteryPercentItemView
- (id)contentsImage
{
    if(!isEnabled) return %orig;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    NSString *percentAsText = [formatter stringFromNumber:[NSNumber numberWithInt:[MSHookIvar<NSString *>(self, "_percentString") intValue]]];
    
    [formatter release];
    
    return [self imageWithText:shouldShowPercentSymbol ? [percentAsText stringByAppendingString:@"%"] : percentAsText];
}
%end

static void loadSettings()
{
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.fortysixandtwo.percentext.plist"];
    
    if([settings objectForKey:@"isEnabled"]) isEnabled = [[settings objectForKey:@"isEnabled"] boolValue];
    if([settings objectForKey:@"showPercentSymbol"]) shouldShowPercentSymbol = [[settings objectForKey:@"showPercentSymbol"] boolValue];
    
    [settings release];
}

static void reloadPrefsNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    loadSettings();
}

%ctor
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&reloadPrefsNotification, CFSTR("com.fortysixandtwo.percentext/settingschanged"), NULL, 0);
    
    loadSettings();
    [pool drain];
}