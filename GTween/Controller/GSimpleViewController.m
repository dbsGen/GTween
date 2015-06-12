//
//  GSimpleViewController.m
//  GTween
//
//  Created by zrz on 14-8-4.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GSimpleViewController.h"
#import "GTween.h"

@interface GSimpleViewController ()

@end

@implementation GSimpleViewController {
    GTween *_tween;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Simple example";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(220, 100, 90, 30);
    [button setTitle:@"Check me!"
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(startTween)
     forControlEvents:UIControlEventTouchUpInside];
    [self showLabel];
}

- (void)showLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"Nihao";
    label.textColor = [UIColor blackColor];
    label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    label.center = CGPointMake(bounds.size.width/2, -30);
    [self.view addSubview:label];
    
    
    GTween *tween = GTweenMake(label.layer, 1, GEaseBounceOut);
    [tween pointPro:@"position"
               from:label.center
                 to:CGPointMake(bounds.size.width/2, bounds.size.height/2)];
    [tween rotationPro:@"transform"
                  from:-M_PI
                    to:0];
    _tween = tween;
}

- (void)startTween
{
    [_tween reset];
    [_tween start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
