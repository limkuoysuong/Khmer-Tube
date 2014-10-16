//
//  NavigationViewController.m
//  Khmer Tube
//
//  Created by Suong on 8/20/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import "NavigationViewController.h"


@interface NavigationViewController (){
    
}

@end

@implementation NavigationViewController{
    NSArray *menu;
    NSArray *menuName;
    NSString *playlistID;
    
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.view.backgroundColor = [UIColor blueColor];
    // self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    // self.tableView.separatorColor = [UIColor whiteColor];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    menu = @[@"KhmerTube",@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight"];
    menuName = @[@"KhmerTube",@"Comedy", @"Entertainment", @"Film & Animation", @"Game", @"Music", @"People", @"Sport", @"Travel & Events"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [menu count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     UINavigationController *destViewController = (UINavigationController *) segue.destinationViewController;
     destViewController.title = [[menuName objectAtIndex:indexPath.row] capitalizedString];
     
     
     if ([segue.identifier isEqualToString:@"showVideos"]) {
         VideosViewController *VC = (VideosViewController*)segue.destinationViewController;
         VC.LinkName = [menu objectAtIndex:indexPath.row];
     }
     
     if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
         SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
         
         swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
             
             UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
             [navController setViewControllers: @[dvc] animated: NO ];
             [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
         };
         
     }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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



@end
