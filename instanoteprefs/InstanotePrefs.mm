/**
 * Instanote Preferences
 * (c) 2014 Brandon Sachs
 * <bransachs@gmail.com>
 */
#import "InstanotePrefs.h"

@implementation INPrefsListController
    - (id)specifiers {
    	if(_specifiers == nil) {
    		_specifiers = [[self loadSpecifiersFromPlistName:@"InstanotePrefs" target:self] retain];
    	}
    	return _specifiers;
    }

    - (void)loadView
    {
        [super loadView];

        UIViewController *INPrefsVC = ((UIViewController *)self);

        UIBarButtonItem *showSomeLove = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/InstanotePrefs.bundle/heart_empty.png"]
            style:UIBarButtonItemStylePlain
            target:INPrefsVC
            action:@selector(heartButtonClicked)
        ];

        INPrefsVC.navigationItem.rightBarButtonItem = showSomeLove;
    }

    - (void)viewDidLoad
    {
        [super viewDidLoad];
    }

    //apply tint
    - (void)viewWillAppear:(BOOL)animated
    {
        UIViewController *INPrefsVC = ((UIViewController *)self);
        INPrefsVC.view.tintColor =
        INPrefsVC.navigationController.navigationBar.tintColor = IN_TINTCOLOR;
    }

    //un-apply tint when they leave
    - (void)viewWillDisappear:(BOOL)animated
    {
        [super viewWillDisappear:animated];

        UIViewController *INPrefsVC = ((UIViewController *)self);
        INPrefsVC.view.tintColor =
        INPrefsVC.navigationController.navigationBar.tintColor = nil;
    }


    - (void)heartButtonClicked
    {
        UIViewController *INPrefsVC = ((UIViewController *)self);

        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

        SLComposeViewControllerCompletionHandler shareCompletion = ^(SLComposeViewControllerResult result)
        {
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };

        controller.completionHandler = shareCompletion;
        [controller setInitialText:@"#Instanote by @the_zeph. Coming soon to a Cydia near you."];
        [INPrefsVC presentViewController:controller animated:YES completion:Nil];
    }

    - (void)openTwitterClientToMe
    {
        NSString *handle = @"the_zeph";
        NSString *url;

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        {
            url = @"tweetbot://user_profile/";
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        {
            url = @"twitterrific:///profile?screen_name=";
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        {
            url = @"twitter://user?screen_name=";
        }
        else
        {
            url = @"https://mobile.twitter.com/";
        }

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingString:handle]]];
    }
@end