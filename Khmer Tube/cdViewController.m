//
//  cdViewController.m
//  Khmer Tube
//
//  Created by Suong on 8/20/14.
//  Copyright (c) 2014 LKS. All rights reserved.
//

#import "cdViewController.h"
#import "SWRevealViewController.h"

@interface cdViewController ()

@end

@implementation cdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
