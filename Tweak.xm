/**
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */

#import "Instanote.h"

static NSString* INGetNoteForUser(NSString *user)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:user];
}
%group INinit

%hook IGFeedItemHeader

    - (void)profilePictureTapped:(id)fp8
    {
        // get raw text from an accessibility label for the username
        NSString *raw_username = MSHookIvar<NSString *>(self, "_accessibilityLabel");

        // extract username
        NSString *username = [raw_username substringFromIndex:8]; // leading "Photo by "
        username = [username substringToIndex:[username length] - 1]; // trailing "."

        // check if user has saved note
        NSString *saved_note = INGetNoteForUser(username);

        if (saved_note == nil)
        {
        	NSLog(@"[Instanote] No saved note for user %@", username);
        	[self INNewNoteAlertView:username];
        }
        else
        {
        	NSLog(@"[Instanote] Saved note for user %@: %@", username, saved_note);
        }

        // for this tweak, we don't want it navigating to the user profile when
        // tapping the small profile pic. you can still view the user profile by
        // tapping the username label.
        // %orig;
    }


    %new
    - (void)INNewNoteAlertView:(NSString *)username
    {
    	NSString *alertMsg = [NSString stringWithFormat:IN_NO_NOTE_FOUND, username];

    	UIAlertView *INAlert = [[UIAlertView alloc] initWithTitle:IN_ALERT_TITLE
    	    message:alertMsg
    	    delegate:self
    	    cancelButtonTitle:IN_CANCEL
    	    otherButtonTitles:IN_SAVE_NOTE, nil];

    	//prompt for note info
    	[INAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];

    	INAlert.tag = 710;
    	[INAlert show];
    	[INAlert release];
    }

%end

%end // group


%ctor
{
    %init(INinit);
}