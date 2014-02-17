//
//  PlaylistPickerViewController.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "PlaylistPickerViewController.h"
#import "CocoaLibSpotify.h"
#import "PlaylistPickerItem.h"

@interface PlaylistPickerViewController ()

@end

@implementation PlaylistPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.chosenPlaylists = [[NSMutableArray alloc] init];
    self.playlistItems   = [[NSMutableArray alloc] init];
    [self loadUserPlaylists];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPlaylistsFromController:(PlaylistPickerViewController *)pickerController {
    
    for (PlaylistPickerItem *pickerItem in self.playlistItems) {
        
        if (pickerItem.chosen) {
            [self.chosenPlaylists addObject:pickerItem.playlist];
        }
    }
    [self.delegate addPlaylistsFromController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.playlistItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PlaylistPickerItem *tempItem = [self.playlistItems objectAtIndex:indexPath.row];
    cell.textLabel.text = tempItem.playlist.name;
    
    if (tempItem.chosen) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PlaylistPickerItem *tappedItem = [self.playlistItems objectAtIndex:indexPath.row];
    tappedItem.chosen = !tappedItem.chosen;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)loadUserPlaylists {
	
	[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedession, NSArray *notLoadedSession) {
		// The session is logged in and loaded — now wait for the userPlaylists to load.
		[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
			// User playlists are loaded — wait for playlists to load their metadata.
			NSMutableArray *playlists = [NSMutableArray array];
			[playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
            
            [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
				
				// All of our playlists have loaded their metadata — wait for all tracks to load their metadata.
				NSLog(@"[%@ %@]: %@ of %@ playlists loaded.", NSStringFromClass([self class]), NSStringFromSelector(_cmd),
					  [NSNumber numberWithInteger:loadedPlaylists.count], [NSNumber numberWithInteger:loadedPlaylists.count + notLoadedPlaylists.count]);
				
                NSMutableArray *tempPlaylists = [[NSMutableArray alloc] initWithArray:loadedPlaylists];
                
                for (int i=0; i<tempPlaylists.count; i++) {
                    
                    [self.playlistItems addObject:[[PlaylistPickerItem alloc] initWithPlaylist:[tempPlaylists objectAtIndex:i]]];
                }
                
                [self.tableView reloadData];
                NSLog(@"what is this help %@", self.playlistItems);
            }];
        }];
    }];
}

- (IBAction)didPressDone:(id)sender {
    
    [self addPlaylistsFromController:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
