/**
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */

#import "Instanote.h"

static NSString *INGetNoteForUser(NSString *user)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:user];
}

static void INSaveNoteForUser(NSString *user, NSString *note)
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:note forKey:user];
    [settings synchronize];
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

        // save username
        objc_setAssociatedObject(self, @selector(_INUser), username, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        if (saved_note == nil)
        {
            NSLog(@"[Instanote] No saved note for user %@.", username);
            [self INNewNoteForUser:username];
        }
        else
        {
            NSLog(@"[Instanote] Saved note for user %@: %@.", username, saved_note);
            [self INShowNote:saved_note];
        }

        // for this tweak, we don't want it navigating to the user profile when
        // tapping the small profile pic. you can still view the user profile by
        // tapping the username label.
        // %orig;
    }

    // new note dialog
    %new
    - (void)INNewNoteForUser:(NSString *)username
    {
        NSString *alertMsg = [NSString stringWithFormat:IN_NEW_NOTE_ALERT_DIALOG, username];

        UIAlertView *IMNewNoteAlert = [[UIAlertView alloc] initWithTitle:IN_NEW_NOTE_ALERT_TITLE
            message:alertMsg
            delegate:self
            cancelButtonTitle:IN_NEW_NOTE_CANCEL_BUTTON
            otherButtonTitles:IN_NEW_NOTE_SAVE_BUTTON, nil];

        [IMNewNoteAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];

        IMNewNoteAlert.tag = 710;
        [IMNewNoteAlert show];
        [IMNewNoteAlert release];
    }

    // show note dialog
    %new
    - (void)INShowNote:(NSString *)note
    {
        NSString *username = objc_getAssociatedObject(self, @selector(_INUser));
        NSString *title = [NSString stringWithFormat:IN_SHOW_NOTE_ALERT_TITLE, username];

        UIAlertView *IMShowNoteAlert = [[UIAlertView alloc] initWithTitle:title
            message:note
            delegate:self
            cancelButtonTitle:IN_SHOW_NOTE_EDIT_BUTTON
            otherButtonTitles:IN_SHOW_NOTE_DISMISS_BUTTON, nil];

        IMShowNoteAlert.tag = 420;
        [IMShowNoteAlert show];
        [IMShowNoteAlert release];
    }

    // alert responses
    %new
    - (void)alertView:(UIAlertView *)INNewNote clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (INNewNote.tag == 710)
        {
            NSString *username = objc_getAssociatedObject(self, @selector(_INUser));
            UITextField *note = [INNewNote textFieldAtIndex:0];

            if ( ! (note.text && note.text.length))
                return;

            NSLog(@"[Instanote] Creating note \"%@\" for user %@.", note.text, username);
            INSaveNoteForUser(username, note.text);
        }
    }

%end

%end // group


%ctor
{
    %init(INinit);
}