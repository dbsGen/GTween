//
//  GViewController.m
//  GTween
//
//  Created by zrz on 14-7-27.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GViewController.h"
#import "GTestObject.h"
#import "GTween.h"

@interface GViewController ()

@end

@implementation GViewController {
    UIView *_movingView, *_targetView;
    GTween *_tween;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1;
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.frame = CGRectMake(200, 10, 80, 30);
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 2;
    [button setTitle:@"pause" forState:UIControlStateNormal];
    button.frame = CGRectMake(200, 50, 80, 30);
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 3;
    [button setTitle:@"backword" forState:UIControlStateNormal];
    button.frame = CGRectMake(200, 90, 80, 30);
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    _movingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _movingView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_movingView];
    
    
    _targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 480, 30, 30)];
    _targetView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_targetView];
    
    GTween *tweenTarget = [GTween tween:_targetView
                               duration:4
                                   ease:[GEaseLinear class]];
    [tweenTarget pointPro:@"center"
                       to:CGPointMake(300, 465)];
    
    GTween *tweenMove = [GTween tween:_movingView
                             duration:4
                                 ease:[GEaseQuarticIn class]];
    [tweenMove dynamicTarget:_targetView
                       names:@[@"center"]
             tweenProperties:@[[GTweenCGPointProperty class]]];
    
    [tweenTarget start];
    [tweenMove start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _tween = nil;
    _movingView = nil;
}

- (void)clicked:(UIButton*)send
{
    if (send.tag == 1) {
        [_tween start];
    }else if (send.tag == 2) {
        [_tween pause];
    }else if (send.tag == 3) {
        [_tween backword];
    }
}

@end
