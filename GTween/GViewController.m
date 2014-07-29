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
    UIView *_movingView;
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    _movingView = view;
    
    GTweenChain *chain = [GTweenChain tweenChain];
    chain.isLoop = true;
    
    GTween *tween = [GTween tween:_movingView
                         duration:1
                             ease:[GEaseBackOut class]];
    [tween pointPro:@"center"
               from:CGPointMake(180, 50)
                 to:CGPointMake(180, 250)];
    [tween colorPro:@"backgroundColor" to:[UIColor blueColor]];
    [chain addTween:tween];
    
    GTween *tween2 = [GTween tween:_movingView
                          duration:1
                              ease:[GEaseBounceOut class]];
    [tween2 pointPro:@"center"
                from:CGPointMake(180, 250)
                  to:CGPointMake(50, 250)];
    [tween2 colorPro:@"backgroundColor"
               from:[UIColor blueColor]
                 to:[UIColor redColor]];
    [chain addTween:tween2];
    chain.isLoop = false;
    
    _tween = chain;
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
