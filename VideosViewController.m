//
//  VideosViewController.m
//  Khmer Tube
//
//  Created by Suong on 8/21/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoListCell.h"
#import "UIImageView+WebCache.h"
#import "VideoViewController.h"

@interface VideosViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation VideosViewController{
    NSMutableArray *arrayItems;
    NSMutableArray *arrayVideoID;
    NSMutableArray *videoTitle;
    NSMutableArray *videoDuration;
    NSMutableArray *videoView;
    NSMutableArray *videoLike;
    NSMutableArray *videoDislike;
}

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
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    if (self.LinkName == NULL) {
        self.LinkName = @"One";
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Videos"];
    [query whereKey:@"category" equalTo:[NSString stringWithFormat:@"%@",self.LinkName]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects) {
                NSString *urlParser=[NSString stringWithFormat:@"https://gdata.youtube.com/feeds/api/playlists/%@?v=2&alt=json",[object objectForKey:@"playlistID"]];
                NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlParser]];
                
                NSError *error;
                NSMutableDictionary *allCourses = [NSJSONSerialization
                                                   JSONObjectWithData:allCoursesData
                                                   options:NSJSONReadingMutableContainers
                                                   error:&error];
                arrayItems = [[NSMutableArray alloc]init];
                arrayVideoID = [[NSMutableArray alloc]init];
                videoTitle = [[NSMutableArray alloc]init];
                videoDuration = [[NSMutableArray alloc]init];
                videoView = [[NSMutableArray alloc]init];
                videoLike = [[NSMutableArray alloc]init];
                videoDislike = [[NSMutableArray alloc]init];
                
                if(error)
                {
                    NSLog(@"%@", [error localizedDescription]);
                }
                else {
                    NSDictionary *newFeed = allCourses[@"feed"];
                    NSArray *newEnery = newFeed[@"entry"];
                    for (int i=0; i<newEnery.count; i++) {
                        NSDictionary *data = [newEnery objectAtIndex:i];
                        //NSLog(@"All Data Key = %@",[data allKeys]);
                        //NSLog(@"All Data = %@",data);
                        
                        NSLog(@"Thumbnails = %@",[[[data[@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:1]objectForKey:@"url"]);
                        NSString *stringUrl = [[[data[@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:1]objectForKey:@"url"];
                        NSLog(@"Title = %@",[data[@"title"]objectForKey:@"$t"]);
                        
                        NSString * videoTitleStr = [data[@"title"]objectForKey:@"$t"];
                        NSString * videoDurationStr = [[data[@"media$group"]objectForKey:@"yt$duration"]objectForKey:@"seconds"];
                        NSString * videoViewStr = [data[@"yt$statistics"]objectForKey:@"viewCount"];
                        
                        
                        NSLog(@"Duration = %@",[[data[@"media$group"]objectForKey:@"yt$duration"]objectForKey:@"seconds"]);
                        NSLog(@"Link = %@",[[data[@"link"]objectAtIndex:2]objectForKey:@"href"]);
                        NSString *VideoIDList = [[data[@"media$group"]objectForKey:@"yt$videoid"]objectForKey:@"$t"];
                        NSLog(@"Video ID = %@",[[data[@"media$group"]objectForKey:@"yt$videoid"]objectForKey:@"$t"]);
                        NSLog(@"View Count = %@",[data[@"yt$statistics"]objectForKey:@"viewCount"]);
                        NSLog(@"Likes = %@",[data[@"yt$rating"]objectForKey:@"numLikes"]);
                        NSLog(@"Dislikes = %@",[data[@"yt$rating"]objectForKey:@"numDislikes"]);
                        
                        NSString * videoLikeStr = [data[@"yt$rating"]objectForKey:@"numLikes"];
                        NSString * videoDislikeStr = [data[@"yt$rating"]objectForKey:@"numDislikes"];
                        
                        if (videoLikeStr == NULL) {
                            videoLikeStr = @"0";
                        }
                        if (videoDislikeStr == NULL) {
                            videoDislikeStr = @"0";
                        }
                        
                        NSLog(@"Like count = %@", videoLikeStr);
                        NSLog(@"DisLike count = %@", videoDislikeStr);
                        
                        
                        //self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringUrl]]];
                        [arrayVideoID addObject:VideoIDList];
                        NSLog(@"this is list id = %@", VideoIDList);
                        
                        [videoLike addObject:videoLikeStr];
                        [videoDislike addObject:videoDislikeStr];
                        [videoTitle addObject:videoTitleStr];
                        [videoDuration addObject:videoDurationStr];
                        [videoView addObject:videoViewStr];
                        
                        [arrayItems addObject:stringUrl];
                        // NSLog(@"test");
                         NSLog(@"It's a title = %@", videoTitle[0]);
                    }
                    
                }
            }
            [self.collectionView reloadData];
        } else {
            
            // Log details of the failure
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        
    }];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayItems.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // PFObject *videoObject = [arrayVideoID objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoViewController *videoVC = [storyboard instantiateViewControllerWithIdentifier:@"videoview"];
    
    NSString *videoKeyHolder = [arrayVideoID objectAtIndex:indexPath.row];
    videoVC.videoKey = videoKeyHolder;
    videoVC.userID = @"asdfsadfs";
    videoVC.countLike = @"2";
    NSLog(@"%@",videoKeyHolder);
    [self.navigationController pushViewController:videoVC animated:YES];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoListCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"exampleCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor blackColor];
    //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrayItems objectAtIndex:indexPath.row]]]];
    //PFFile *file =
    //PFImageView *imageView = (PFImageView *)[cell viewWithTag:100];
    //imageView.file. = [NSURL URLWithString:[arrayItems objectAtIndex:indexPath.row]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[arrayItems objectAtIndex:indexPath.row]]
                      placeholderImage:[UIImage imageNamed:@"theVoice_placeholder.png"]];
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.imageView.layer.borderWidth = 1;
    
    cell.videoTitleLabel.text = [videoTitle objectAtIndex:indexPath.row];
    //cell.videoTitleLabel.font = [UIFont fontWithName:@"KhmerOSBattambang" size:11];
    cell.videoDurationLabel.text = [self formatTimeFromSeconds:[[videoDuration objectAtIndex:indexPath.row]intValue]];
    
     cell.videoLikeLabel.text = [videoLike objectAtIndex:indexPath.row];
     cell.videoDislikeLabel.text = [videoDislike objectAtIndex:indexPath.row];
     cell.videoViewLabel.text = [NSString stringWithFormat:@"%@ views", [videoView objectAtIndex:indexPath.row]] ;
   
    //cell.imageView sd_setImageWithURL:[NSURL URLWithString:] placeholderImage:<#(UIImage *)#>
    return cell;
}

-(NSString *)formatTimeFromSeconds:(int)numberOfSeconds
{
    int seconds = numberOfSeconds % 60;
    int minutes = (numberOfSeconds / 60) % 60;
    int hours = numberOfSeconds / 3600;
    
    //we have >=1 hour => example : 3h:25m
    if (hours) {
        return [NSString stringWithFormat:@"%dh:%02dm", hours, minutes];
    }
    //we have 0 hours and >=1 minutes => example : 3m:25s
    if (minutes) {
        return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }
    //we have only seconds example : 25s
    return [NSString stringWithFormat:@"%d", seconds];
}


@end
