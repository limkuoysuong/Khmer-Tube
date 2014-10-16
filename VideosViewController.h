//
//  VideosViewController.h
//  Khmer Tube
//
//  Created by Suong on 8/21/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UILabel *LinkLabel;
@property (strong, nonatomic) NSString * LinkName;
@property (strong, nonatomic) NSString * defaultLink;

@end
