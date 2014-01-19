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
#import <Parse/Parse.h>
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.hostButton.buttonColor = [UIColor turquoiseColor];
    self.hostButton.shadowColor = [UIColor greenSeaColor];
    self.hostButton.shadowHeight = 3.0f;
    self.hostButton.cornerRadius = 6.0f;
    self.hostButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.hostButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.hostButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.joinButton.buttonColor = [UIColor turquoiseColor];
    self.joinButton.shadowColor = [UIColor greenSeaColor];
    self.joinButton.shadowHeight = 3.0f;
    self.joinButton.cornerRadius = 6.0f;
    self.joinButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.joinButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
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
