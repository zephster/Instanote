/**
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */

/**
 * 	settings
 * 		kill switch (duh)
 * 		table with all saved notes that you can edit right there
 * 		thats it.
 */

#import "Instanote.h"

%group INinit

%hook IGFeedItemHeader

	- (void)profilePictureTapped:(id)fp8
	{
		// get raw text from an accessibility label for the username
		NSString *raw_username = MSHookIvar<NSString *>(self, "_accessibilityLabel");

		// extract username
        NSString *username = [raw_username substringFromIndex:8]; // leading "Photo by "
        username = [username substringToIndex:[username length] - 1]; // trailing "."


        NSString *alertMsg = [NSString stringWithFormat:@"No notes found for %@.", username];

        UIAlertView *INAlert = [[UIAlertView alloc] initWithTitle:@"Instanote"
            message:alertMsg
            delegate:self
            cancelButtonTitle:@"Cancel"
            otherButtonTitles:@"Save Note", nil];

        //prompt for note info
        [INAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];

        INAlert.tag = 710;
        [INAlert show];
        [INAlert release];

        // for this tweak, we don't want it navigating to the user profile when
        // tapping the small profile pic. you can still view the user profile by
        // tapping the username label.
        // %orig;
	}

%end

%end // group



%ctor
{
	%init(INinit);
}