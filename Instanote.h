/*
 * Instanote
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */
#import <UIKit/UIKit.h>
#import "substrate.h"

#define IN_ALERT_TITLE @"Instanote"
#define IN_NO_NOTE_FOUND @"Enter note for %@."
#define IN_SAVE_NOTE @"Save Note"
#define IN_CANCEL @"Cancel"

@interface IGFeedItemHeader{
    NSString *_INUser;
}
- (void)profilePictureTapped:(id)fp8;
- (void)INNewNoteForUser:(NSString *)username;
@end