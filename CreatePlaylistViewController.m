//
//  CreatePlaylistViewController.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "CreatePlaylistViewController.h"
#import "PlaylistTableViewController.h"

@interface CreatePlaylistViewController ()

@end

@implementation CreatePlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)createPlaylist:(id)sender {
   
    [self performSegueWithIdentifier:@"createPlaylistSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"createPlaylistSegue"]) {
        
        UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
        
        UINavigationController *navigationController = [tabBarController viewControllers][1];
        
        PlaylistTableViewController *controller = (PlaylistTableViewController *)[navigationController viewControllers][0];
        
        controller.playlist = [[Playlist alloc] init];
        controller.playlist.name = self.nameField.text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
