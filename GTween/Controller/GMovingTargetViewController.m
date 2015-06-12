//
//  GMovingTargetViewController.m
//  GTween
//
//  Created by zrz on 14-8-5.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GMovingTargetViewController.h"
#import "GTween.h"

@interface GMovingTargetViewController ()

@end

@implementation GMovingTargetViewController {
    GTween  *_tween1, *_tween2;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 50, 30, 30)];
    view1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view1];

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(270, 50, 40, 40)];
    view2.backgroundColor = [UIColor redColor];
    [self.view insertSubview:view2 belowSubview:view1];
    
    _tween1 = [GTween tween:view1
                   duration:2
                       ease:[GEaseSinusoidalIn class]];
    [_tween1 dynamicTarget:view2
                     names:@[@"center"]
           tweenProperties:@[[GTweenCGPointProperty class]]];
    
    _tween2 = [GTween tween:view2
                   duration:2
                       ease:[GEaseLinear class]];
    [_tween2 pointPro:@"center"
                 from:view2.center
                   to:CGPointMake(290, 360)];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clicked:(id)sender
{
    [_tween2 reset];
    [_tween2 start];
    [_tween1.target setCenter:CGPointMake(20, 65)];
    [_tween1 reset];
    [_tween1 start];
}

@end
