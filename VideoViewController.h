//
//  VideoViewController.h
//  The Voice
//
//  Created by Lim Kuoy Suong on 8/9/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GADInterstitial.h"
#import <QuartzCore/QuartzCore.h>

//@interface VideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, GADInterstitialDelegate>

@interface VideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString *videoKey;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *user;
@property (nonatomic,strong) NSString *countLike;
@property (strong, nonatomic) NSMutableArray *objectTheSameKey;

//@property (strong, nonatomic) GADInterstitial * interstitial;
//- (GADRequest *) request;

@end
