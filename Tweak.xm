/**
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */

#import "Instanote.h"

%hook IGFeedItemHeader


	- (void)profilePictureTapped:(id)fp8
	{
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		NSLog(@"=============== INSTANOTE profilePicturetapped OMG =============");
		%log;
		%orig;

        NSString *string = MSHookIvar<NSString *>(self, "_accessibilityLabel");
        NSLog(@"username string");
        NSLog(@"%@", string);


        NSString *formattedUN = [string substringFromIndex:8];
        formattedUN = [formattedUN substringToIndex:[formattedUN length] - 1];
        NSLog(@"formatted username:");
        NSLog(@"%@", formattedUN);
	}

%end