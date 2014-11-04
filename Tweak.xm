/**
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */

#import "Instanote.h"

static NSMutableDictionary *INSavedUserNotes;

static void INLoadUserNotes()
{
    if (INSavedUserNotes)
    {
        [INSavedUserNotes release];
    }

    INSavedUserNotes = [NSMutableDictionary dictionaryWithContentsOfFile:IN_SETTINGS_FILE];
}

static NSString *INGetNoteForUser(NSString *user)
{
    return [INSavedUserNotes valueForKey:user];
}

static bool INSaveNoteForUser(NSString *user, NSString *note)
{
    [INSavedUserNotes setObject:note forKey:user];
    return [INSavedUserNotes writeToFile:IN_SETTINGS_FILE atomically:YES];
}

%group INinit

%hook IGFeedItemHeader

    - (void)profilePictureTapped:(id)fp8
    {
        // get raw text from an accessibility label for the username
        NSString *raw_username = MSHookIvar<NSString *>(self, "_accessibilityLabel");

        // remove leading "Photo by "
        NSString *username = [raw_username substringFromIndex:8];

        // location removal
        NSRange loc_info = [username rangeOfString:@"Taken at"];
        if (loc_info.location != NSNotFound)
        {
            username = [username substringToIndex:loc_info.location];
        }

        // remove trailing period
        username = [username substringToIndex:[username length] - 1];

        // check if user has saved note
        NSString *saved_note = INGetNoteForUser(username);

        // save username for use in alert views
        objc_setAssociatedObject(self, @selector(_INUser), username, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        if (saved_note == nil)
        {
            NSLog(@"[Instanote] No saved note for user %@.", username);
            [self INEditNoteForUser:username];
        }
        else
        {
            NSLog(@"[Instanote] Showing note for user %@: %@.", username, saved_note);
            [self INShowNote:saved_note forUser:username];
        }

        // for this tweak, we don't want it navigating to the user profile when
        // tapping the small profile pic. you can still view the user profile by
        // tapping the username label.
        // %orig;
    }

    // edit note dialog
    %new
    - (void)INEditNoteForUser:(NSString *)username
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
    - (void)INShowNote:(NSString *)note forUser:(NSString *)username
    {
        NSString *title = [NSString stringWithFormat:IN_SHOW_NOTE_ALERT_TITLE, username];

        // i'm using cancel as the actionable button because its position
        // requires a more intentional touch than the instinctive "OK"
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
    - (void)alertView:(UIAlertView *)INDialogResult clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        NSString *username = objc_getAssociatedObject(self, @selector(_INUser));
        
        // save new note
        if (INDialogResult.tag == 710)
        {
            UITextField *note = [INDialogResult textFieldAtIndex:0];

            if ( ! (note.text && note.text.length))
                return;

            NSLog(@"[Instanote] Creating note \"%@\" for user %@.", note.text, username);
            INSaveNoteForUser(username, note.text);
        }

        // edit note tapped
        if (INDialogResult.tag == 420)
        {
            if (buttonIndex == [INDialogResult cancelButtonIndex])
            {
                NSLog(@"[Instanote] Editing note for user %@.", username);
                [self INEditNoteForUser:username];
            }
        }
    }

%end

%end // group


%ctor
{
    INLoadUserNotes();
    %init(INinit);
}