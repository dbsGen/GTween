//
//  GChainViewController.m
//  GTween
//
//  Created by zrz on 14-8-4.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GChainViewController.h"
#import "GTween.h"

@interface GChainViewController ()

@end

@implementation GChainViewController {
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
    // Do any additional setup after loading the view.
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
