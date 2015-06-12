//
//  GPauseAndResumeViewController.m
//  GTween
//
//  Created by zrz on 14-8-5.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GPauseAndResumeViewController.h"
#import "GTween.h"

@interface GPauseAndResumeViewController ()

@end

@implementation GPauseAndResumeViewController{
    GTween *_tween;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    block.backgroundColor = [UIColor redColor];
    block.center = CGPointMake(40, 80);
    [self.view addSubview:block];
    
    GTweenChain *chain = [[GTweenChain alloc] init];
    
    GTween *tween = [GTween tween:block
                         duration:0.5
                             ease:[GEaseLinear class]];
    [tween pointPro:@"center"
                 to:CGPointMake(280, 80)];
    [chain addTween:tween];
    
    tween = [GTween tween:block
                 duration:0.5
                     ease:[GEaseLinear class]];
    [tween pointPro:@"center"
                 to:CGPointMake(280, 300)];
    [chain addTween:tween];
    
    tween = [GTween tween:block
                 duration:0.5
                     ease:[GEaseLinear class]];
    [tween pointPro:@"center"
                 to:CGPointMake(40, 300)];
    [chain addTween:tween];
    
    tween = [GTween tween:block
                 duration:0.5
                     ease:[GEaseLinear class]];
    [tween pointPro:@"center"
                 to:CGPointMake(40, 80)];
    [chain addTween:tween];
    chain.isLoop = YES;
    
    [chain start];
    _tween = chain;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Play"
            forState:UIControlStateNormal];
    button.frame = CGRectMake(5, 390, 100, 34);
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    button.tag = 0;
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 3;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Pause"
            forState:UIControlStateNormal];
    button.frame = CGRectMake(110, 390, 100, 34);
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    button.tag = 1;
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 3;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Backword"
            forState:UIControlStateNormal];
    button.frame = CGRectMake(215, 390, 100, 34);
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    button.tag = 2;
    [button addTarget:self
               action:@selector(clicked:)
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 3;
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clicked:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
            [_tween start];
            break;
        case 1:
            [_tween pause];
            break;
        case 2:
            [_tween backword];
            break;
            
        default:
            break;
    }
}

@end
