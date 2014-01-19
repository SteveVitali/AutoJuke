//
//  JoinPlaylistViewController.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "JoinPlaylistViewController.h"
#import "SlavePlaylistViewController.h"
#import "Playlist.h"

@interface JoinPlaylistViewController ()

@end

@implementation JoinPlaylistViewController

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

- (IBAction)joinPlaylist:(id)sender {
    
    [self performSegueWithIdentifier:@"joinPlaylistSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"joinPlaylistSegue"]) {
        SlavePlaylistViewController *controller = (SlavePlaylistViewController *)[segue destinationViewController];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Playlist"];
        [query whereKey:@"name" equalTo:self.nameField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved stuff");
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"object id: %@", object.objectId);
                    
                    controller.playlist = [[Playlist alloc] init];

                    controller.playlist.name = object[@"name"];
                    controller.playlist.songTitles = [[NSMutableArray alloc] initWithArray:object[@"songTitles"]];
                    controller.playlist.songTitles = object[@"songTitles"];
                    controller.playlist.songURIs   = object[@"songURIs"];
                    controller.navigationItem.title = controller.playlist.name;
                    [controller.tableView reloadData];
                    NSLog(@"something else: %d",controller.playlist.songURIs.count);
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
