//
//  GViewController.m
//  GTween
//
//  Created by zrz on 14-7-27.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GViewController.h"
#import "GSimpleViewController.h"
#import "GChainViewController.h"
#import "GPauseAndResumeViewController.h"
#import "GMovingTargetViewController.h"
#import "GTestObject.h"
#import "GTween.h"

@interface GViewController ()

@end

@implementation GViewController {
    UIView *_movingView, *_targetView;
    GTween *_tween;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"GTween";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _tween = nil;
    _movingView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Simple example";
            break;
        case 1:
            cell.textLabel.text = @"Tween chain";
            break;
        case 2:
            cell.textLabel.text = @"Pause & Resume";
            break;
        case 3:
            cell.textLabel.text = @"Moving target";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[GSimpleViewController new]
                                                 animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[GChainViewController new]
                                                 animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[GPauseAndResumeViewController new]
                                                 animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[GMovingTargetViewController new]
                                                 animated:YES];
            break;
        default:
            break;
    }
}

@end
