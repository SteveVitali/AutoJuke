//
//  AppDelegate.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/17/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "AppDelegate.h"
#import "CocoaLibSpotify.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "appkey.c"

#define SP_LIBSPOTIFY_DEBUG_LOGGING 1

@implementation AppDelegate

BOOL loggedIn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**************************************
     ** Set Up ViewController References **
     **************************************/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
	// if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
	    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.viewController = [storyboard instantiateInitialViewController];
	}
    
	self.window.rootViewController = self.viewController;
    
    /***********************
     ** Set up Parse API  **
     ***********************/
    
    [Parse setApplicationId:@"Lwkw4PMt3tatJojVJkjSV9zLxtkA6wIh6q5yXuBl"
                  clientKey:@"mIBC4cPOGGbOwKZcXaVdmAGabxDwGp4NuK1mRoGy"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /******************************
     ** Set up Cocoa/Spotify API **
     ******************************/
    
    // init SPSession ( CocoaLibSession )
    
    NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.spotify.SimplePlayer-iOS"
										   loadingPolicy:SPAsyncLoadingManual
												   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    [[SPSession sharedSession] setDelegate:self];
    
    // Log User In
    
    if (! [self loginWithStoredCredentials]) {
        [self showLoginView];
    }
    
    // END appDidFinishLaunching[...] delegate code

    return YES;
}

-(void)clearStoredCredentials {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpotifyUsers"];
}

-(BOOL)loginWithStoredCredentials {
    NSDictionary *storedCredentials = [[NSUserDefaults standardUserDefaults]
                                       valueForKey:@"SpotifyUsers"];
    
    if (storedCredentials.count > 0)
        // if there are credentials
    {
        NSLog(@"Credentials found: Setting...");
        
        NSString *username = [storedCredentials allKeys][0];
        NSString *credential = [storedCredentials valueForKey:username];
        
        NSLog(@"username: %@", username);
        if (credential == nil) NSLog(@"credential string invalid");
        
        [[SPSession sharedSession] attemptLoginWithUserName:username
                                         existingCredential:credential];
        
        if (! loggedIn)
        // if the credentials don't work out
        {
            [self clearStoredCredentials];
            return false;
        }
    }
    else
    // there are no credentials
    {
        [self performSelector:@selector(showLoginView) withObject:nil afterDelay:0.0];
        return false;
    }
    
    return true;
}

-(void)showLoginView {
    
	SPLoginViewController *spotifyLogin = [SPLoginViewController
                                           loginControllerForSession:[SPSession sharedSession]];
	spotifyLogin.allowsCancel = NO;
	// ^ To allow the user to cancel (i.e., your application doesn't require a logged-in Spotify user, set this to YES.
	[self.viewController presentViewController:spotifyLogin animated:NO completion:nil];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	__block UIBackgroundTaskIdentifier identifier = [application beginBackgroundTaskWithExpirationHandler:^{
		[[UIApplication sharedApplication] endBackgroundTask:identifier];
	}];
    
	[[SPSession sharedSession] flushCaches:^{
		if (identifier != UIBackgroundTaskInvalid)
			[[UIApplication sharedApplication] endBackgroundTask:identifier];
	}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark SPSessionDelegate Methods

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession {
	// Called after a successful login.
    
	[SPAsyncLoading waitUntilLoaded:aSession timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		[SPAsyncLoading waitUntilLoaded:aSession.user timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Hello %@!", aSession.user.displayName]
															message:@"Something, something AutoJuke."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}];
	}];
    
    loggedIn = true;
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error {
	// Called after a failed login. SPLoginViewController will deal with this for us.
}

-(void)sessionDidLogOut:(SPSession *)aSession; {
	// Called after a logout has been completed.
    
    loggedIn = false;
}

-(void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential
                                                     forUserName:(NSString *)userName {
    NSLog(@"SPSession logged in; login credentials generated.");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *storedCredentials = [[defaults valueForKey:@"SpotifyUsers"] mutableCopy];
    
    if (storedCredentials == nil) {
        NSLog(@"No stored credentials; initializing...");
        storedCredentials = [NSMutableDictionary dictionary];
    } else {
        NSLog(@"didGenerateLoginCredentials only supports 1 saved user blob.");
        NSLog(@"initializing new credentials..");
        storedCredentials = [NSMutableDictionary dictionary];
    }
    
    [storedCredentials setValue:credential forKey:userName];
    [defaults setValue:storedCredentials forKey:@"SpotifyUsers"];
}

-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {
	if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
		NSLog(@"CocoaLS NETWORK ERROR: %@", error);
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {
	if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
		NSLog(@"CocoaLS DEBUG: %@", aMessage);
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession; {
	// Called when metadata has been updated somewhere in the
	// CocoaLibSpotify object model. You don't normally need to do
	// anything here. KVO on the metadata you're interested in instead.
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
	// Called when the Spotify service wants to relay a piece of information to the user.
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aMessage
													message:@"This message was sent to you from the Spotify service."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}


@end