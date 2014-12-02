//
//  ViewController.m
//  Snowflakes
//
//  Created by Hamming, Tom on 12/2/14.
//  Copyright (c) 2014 Tom Hamming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSTimeInterval sleepTime = 0.3;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        sleepTime = 0.15;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       while (true)
                       {
                           [NSThread sleepForTimeInterval:sleepTime];
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              CGFloat width = (arc4random() % 80) + 20;
                                              CGFloat xCoord = arc4random() % (int)self.view.frame.size.width;
                                              CGRect startRect = CGRectMake(xCoord, width * -1, width, width);
                                              UIImageView *view = [[UIImageView alloc]initWithFrame:startRect];
                                              [self.view addSubview:view];
                                              view.image = [UIImage imageNamed:@"flake.png"];
                                              CGRect endRect = CGRectMake(xCoord, self.view.frame.size.height, width, width);
                                              NSTimeInterval time = 16 + (arc4random() % 8);
                                              [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^
                                               {
                                                   view.frame = endRect;
                                                   view.transform = CGAffineTransformMakeRotation(M_PI);
                                               } completion:^(BOOL finished)
                                               {
                                                   [view removeFromSuperview];
                                               }];
                                          });
                       }
                   });
}

@end
