/*
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */
#import <UIKit/UIKit.h>
#import "substrate.h"

#define IN_NEW_NOTE_ALERT_TITLE @"Instanote"
#define IN_NEW_NOTE_ALERT_DIALOG @"Enter note for %@."
#define IN_NEW_NOTE_SAVE_BUTTON @"Save Note"
#define IN_NEW_NOTE_CANCEL_BUTTON @"Cancel"
 
#define IN_SHOW_NOTE_ALERT_TITLE @"Instanote for %@"
#define IN_SHOW_NOTE_DISMISS_BUTTON @"Dismiss"
#define IN_SHOW_NOTE_EDIT_BUTTON @"Edit"

@interface IGFeedItemHeader{
    NSString *_INUser;
}
- (void)profilePictureTapped:(id)fp8;
- (void)INNewNoteForUser:(NSString *)username;
- (void)INShowNote:(NSString *)note;
@end