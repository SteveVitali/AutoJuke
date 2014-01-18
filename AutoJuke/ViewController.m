//
//  ViewController.m
//  AutoJuke
//
//  Created by Sam Moore on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "ViewController.h"
#import "CreatePlaylistViewController.h"
#import "JoinPlaylistViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressHostButton:(id)sender {
    
    [self performSegueWithIdentifier:@"hostSegue" sender:self];
}

- (IBAction)didPressJoinButton:(id)sender {
    
    [self performSegueWithIdentifier:@"joinSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"hostSegue"]) {
        CreatePlaylistViewController *controller =
        (CreatePlaylistViewController *)[segue destinationViewController];
        
    }
    else if([segue.identifier isEqualToString:@"joinSegue"]) {
        JoinPlaylistViewController *controller =
        (JoinPlaylistViewController *)[segue destinationViewController];
        // other stuff
    }
}


@end
