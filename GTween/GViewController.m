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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    _movingView = view;
    
    GTweenChain *chain = [GTweenChain tweenChain];
    chain.isLoop = true;
    
    GTween *tween = [GTween tween:_movingView.layer
                         duration:1
                             ease:[GEaseBackOut class]];
    [tween addProperty:[GTweenCGPointProperty property:@"position"
                                                  from:CGPointMake(10, 10)
                                                    to:CGPointMake(180, 250)]];
    [tween addProperty:[GTweenCATransform3DProperty property:@"transform"
                                                        from:CATransform3DIdentity
                                                          to:CATransform3DScale(CATransform3DMakeRotation(1.14, 0, 0, 1), 10, 10, 1)]];
    [chain addTween:tween];
    
    GTween *tween2 = [GTween tween:_movingView.layer
                          duration:1
                              ease:[GEaseBounceOut class]];
    [tween2 addProperty:[GTweenCGPointProperty property:@"position"
                                                  from:CGPointMake(180, 250)
                                                    to:CGPointMake(10, 10)]];
    [tween2 addProperty:[GTweenCATransform3DProperty property:@"transform"
                                                        from:CATransform3DScale(CATransform3DMakeRotation(1.14, 0, 0, 1), 10, 10, 1)
                                                          to:CATransform3DIdentity]];
    [chain addTween:tween2];
    
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
    }else {
        [_tween pause];
    }
}

@end
