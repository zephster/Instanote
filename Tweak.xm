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


        NSString *alertMsg = [NSString stringWithFormat:IN_NO_NOTE_FOUND, username];

        UIAlertView *INAlert = [[UIAlertView alloc] initWithTitle:IN_ALERT_TITLE
            message:alertMsg
            delegate:self
            cancelButtonTitle:IN_CANCEL
            otherButtonTitles:IN_SAVE_NOTE, nil];

        //prompt for note info
        [INAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];

        //NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        // [settings removeObjectForKey:@"AS_SELECTED_ALBUM"];
        // [settings setObject:albumName forKey:@"AS_SELECTED_ALBUM"];
        // [settings synchronize];


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