//
//  VideoListCell.h
//  Khmer Tube
//
//  Created by Suong on 8/21/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoLikeLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoDislikeLabel;

@end
