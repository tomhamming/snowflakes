//
//  ViewController.m
//  Snowflakes
//
//  Created by Hamming, Tom on 12/2/14.
//  Copyright (c) 2014 Tom Hamming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property UIView *minionView;
@property UIView *flakeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.flakeView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.flakeView.backgroundColor = [UIColor clearColor];
    self.flakeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.flakeView];
    
    self.minionView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.minionView.backgroundColor = [UIColor clearColor];
    self.minionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.minionView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSTimeInterval minFlakeTime = 0.09;
    NSTimeInterval maxFlakeTime = 0.2;
    NSTimeInterval minMinionTime = 2;
    NSTimeInterval maxMinionTime = 5;
    CGFloat minWidth = 320;
    CGFloat maxWidth = 1024;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat percentage = (width - minWidth) / (maxWidth - minWidth);
    NSTimeInterval myFlakeTime = maxFlakeTime - (percentage * (maxFlakeTime - minFlakeTime));
    NSTimeInterval myMinionTime = maxMinionTime - (percentage * (maxMinionTime - minMinionTime));
    
    NSLog(@"Flake sleep time: %.3f seconds", myFlakeTime);
    NSLog(@"Minion sleep time: %.3f seconds", myMinionTime);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       while (true)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              CGFloat width = (arc4random() % 40) + 20;
                                              CGFloat xCoord = arc4random() % (int)self.view.bounds.size.width;
                                              xCoord -= (width / 2);
                                              CGRect startRect = CGRectMake(xCoord, width * -1, width, width);
                                              UIImageView *view = [[UIImageView alloc]initWithFrame:startRect];
                                              [self.flakeView addSubview:view];
                                              view.image = [UIImage imageNamed:@"flake"];
                                              CGRect endRect = CGRectMake(xCoord, self.view.bounds.size.height, width, width);
                                              NSTimeInterval time = 16 + (arc4random() % 9);
                                              [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^
                                               {
                                                   view.frame = endRect;
                                                   view.transform = CGAffineTransformMakeRotation(M_PI);
                                               } completion:^(BOOL finished)
                                               {
                                                   [view removeFromSuperview];
                                               }];
                                          });
                           [NSThread sleepForTimeInterval:myFlakeTime];
                       }
                   });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       while (true)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              CGFloat width = 100;
                                              CGFloat xCoord = arc4random() % (int)(self.view.bounds.size.width - width);
                                              CGRect startRect = CGRectMake(xCoord, width * -1, width, width);
                                              UIImageView *view = [[UIImageView alloc]initWithFrame:startRect];
                                              [self.minionView addSubview:view];
                                              view.image = [UIImage imageNamed:@"minion"];
                                              if (arc4random() % 2 == 0)
                                                  view.transform = CGAffineTransformMakeScale(-1, 1);
                                              
                                              CGRect endRect = CGRectMake(xCoord, self.view.bounds.size.height, width, width);
                                              NSTimeInterval time = 20 + (arc4random() % 4);
                                              [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^
                                               {
                                                   view.frame = endRect;
                                               } completion:^(BOOL finished)
                                               {
                                                   [view removeFromSuperview];
                                               }];
                                          });
                           [NSThread sleepForTimeInterval:myMinionTime];
                       }
                   });
}

@end
