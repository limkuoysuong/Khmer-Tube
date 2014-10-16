//
//  VideoViewController.m
//  The Voice
//
//  Created by Lim Kuoy Suong on 8/9/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import "VideoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "cdAppDelegate.h"

@interface VideoViewController ()<UIWebViewDelegate>{
    NSDictionary *youtubeData;
    NSString * title;
    NSString * viewCount;
    int durationCount;
    UITableViewCell *cell;
    NSString *key;
    int heigh;
    int sizeHeight;
    NSString *linkUrl;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewControl;
@property (weak, nonatomic) IBOutlet UIButton *shareOutletButton;

@end


@implementation VideoViewController{
    //UILabel  *titleLable;
    Boolean like;
    //int i;
    UIButton *likeButton;
    NSString *objID;
    UILabel  *countLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeHeight=110;
    heigh=0;
    
    key=self.videoKey;
    NSString *urlParser=[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=jsonc",key];
    
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:
                              [NSURL URLWithString:urlParser]];
    if (allCoursesData == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 50)];
        [titleLabel setBackgroundColor:[UIColor redColor]];
        [titleLabel setText:@"No Internet Connection"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:19]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:titleLabel];
        self.shareOutletButton.hidden = YES;
        self.tableViewControl.hidden = YES;
        return;
    }else{
        self.shareOutletButton.hidden = NO;
        self.tableViewControl.hidden = NO;
    }
    
    NSError *error;
    NSMutableDictionary *allCourses = [NSJSONSerialization
                                       JSONObjectWithData:allCoursesData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    if( error )
    {
        //NSLog(@"%@", [error localizedDescription]);
    }
    else {
        youtubeData = allCourses[@"data"];
        NSDictionary *item;
        NSDictionary *youtubeUrl;
    
        title=[youtubeData objectForKey:@"title"];
        viewCount=[youtubeData objectForKey:@"viewCount"];
        durationCount = [[youtubeData objectForKey:@"duration"] intValue];
        
        item=[youtubeData objectForKey:@"thumbnail"];
        youtubeUrl = [youtubeData objectForKey:@"player"];
        
        linkUrl = [youtubeUrl objectForKey:@"mobile"];
        
    }
    if(title.length>25 && title.length<50)
        heigh=15;
    else if(title.length>50 && title.length<75)
        heigh=30;
    else if(title.length>75 && title.length<100)
        heigh=45;
    else if(title.length>100)
        heigh=60;
    [self displayGoogleVideo];
    
    UIView* row = nil;
    for(row in self.webView.subviews){
        if([row isKindOfClass:[UIScrollView class] ]){
            UIScrollView* scrollRow = (UIScrollView*) row;
            scrollRow.scrollEnabled = NO;
            scrollRow.bounces = NO;
            scrollRow.backgroundColor=[UIColor clearColor];
        }
    }
    
   // NSInteger lost = [[NSUserDefaults standardUserDefaults]integerForKey:@"loseHard"];
//    if (lost == 3) {
//        self.interstitial = [[GADInterstitial alloc]init];
//        self.interstitial.delegate = self;
//        self.interstitial.adUnitID = @"ca-app-pub-1754016809419787/6281512952";
//        [self.interstitial loadRequest:[self request]];
//        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"loseHard"];
//    }
    
    if ([self.userID isEqualToString:@""]) {
        return;
    }
    
    self.objectTheSameKey = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"userId" equalTo:self.userID]; //Check user
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %lu liker.", (unsigned long)objects.count);
            if (objects.count >= 1) {
                PFQuery *queryLike = [PFQuery queryWithClassName:@"Like"];
                [queryLike whereKey:@"like" equalTo:@"t"];
                [queryLike whereKey:@"userId" equalTo:self.userID];
                [queryLike whereKey:@"videoKey" equalTo:self.videoKey];
                
                [queryLike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        //NSLog(@"Successfully retrieved %lu likes.", (unsigned long)objects.count);
                        if (objects.count >= 1) {
                            UIImage *i1uImage = [UIImage imageNamed:@"I want you_select.png"];
                            [likeButton setBackgroundImage:i1uImage forState:UIControlStateNormal];
                            // [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
                            like = false;
                        }
                        else {
                             UIImage *i1uImage = [UIImage imageNamed:@"I want you_Deselect.png"];
                             [likeButton setBackgroundImage:i1uImage forState:UIControlStateNormal];
                            // [likeButton setTitle:@"Like" forState:UIControlStateNormal];
                            like = true;
                        }
                    }
                    else {
                        //NSLog(@"Error");
                    }
                }];
            }
            else {
                //[likeButton setTitle:@"Like" forState:UIControlStateNormal];
                //i = 0;
            }
            
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

// Add Mob
//- (GADRequest *)request {
//    GADRequest *request = [GADRequest request];
//    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
//    // you want to receive test ads.
//    request.testDevices = @[
//                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
//                            // the console when the app is launched.
//                            GAD_SIMULATOR_ID
//                            ];
//    
//    return request;
//}
//
//- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
//{
//    //NSLog(@"successful");
//    [self.interstitial presentFromRootViewController:self];
//    
//}
//
//
//- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
//{
//   // NSLog(@"recied error");
//}

- (void) displayGoogleVideo
{
    
    //CGRect rect = [[UIScreen mainScreen] bounds];
    //CGSize screenSize = rect.size;
    
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
    
    self.webView.autoresizesSubviews = YES;
    
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSString *videoUrl = [NSString stringWithFormat:@"http://www.youtube.com/v/%@",key];
    
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"320\" height=\"180\"><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"180\"></embed></object></div></body></html>",videoUrl,videoUrl]    ;
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
}

-(void)youTubeStarted:(NSNotification *)notification{
    cdAppDelegate *appDelegate = (cdAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = YES;
}

-(void)youTubeFinished:(NSNotification *)notification{

    cdAppDelegate *appDelegate = (cdAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.fullScreenVideoIsPlaying = NO;
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    UIViewController *mVC = [[UIViewController alloc] init];
    [self presentViewController:mVC animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scroll");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel  *titleLable = (UILabel *)[cell viewWithTag:1];
    UILabel  *viewCountLable=(UILabel *)[cell viewWithTag:2];
     viewCountLable.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Th" size:13];
    likeButton =(UIButton *)[cell viewWithTag:3];
    UILabel  *durationLabel = (UILabel *)[cell viewWithTag:4];
    
   // [likeButton addTarget:self action:@selector(buttonLikeAction) forControlEvents:UIControlEventTouchUpInside];
    
    titleLable.lineBreakMode = NSLineBreakByWordWrapping;
    titleLable.numberOfLines = 5;
    
    titleLable.text=title;
    titleLable.font = [UIFont fontWithName:@"KhmerOSKangrey" size:15];
    viewCountLable.text=[NSString stringWithFormat:@"%@ views",viewCount.description ];
    //    [self timeFormatted:durationCount];
    //    durationLabel.text = [NSString stringWithFormat:@"%d", durationCount];
    durationLabel.text = [self formatTimeFromSeconds:durationCount];
    durationLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Th" size:13];
    
    countLabel = (UILabel *)[cell viewWithTag:5];
    countLabel.text = self.countLike;
    
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
        return [NSString stringWithFormat:@"%dm:%02ds", minutes, seconds];
    }
    //we have only seconds example : 25s
    return [NSString stringWithFormat:@"%ds", seconds];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return sizeHeight+heigh;
    else
        return 100;// size.height+1;
}
- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareButton:(UIButton *)sender {
    NSString *appMore = @"See more videos :";
    NSString *appiOS = @"For iOS ";
    NSString *appAndroid = @"Availabel soon";
    NSArray *objectsToShare = @[title,linkUrl,appMore,appiOS,appAndroid];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
