//
//  GTween.m
//  GTween
//
//  Created by zrz on 14-7-27.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GTween.h"

const float frameRace = 60;

@interface GTween ()

- (BOOL)update;

@end

@interface GTweenManager : NSObject

@property (nonatomic, readonly) NSArray *tweens;
+ (id)instance;
- (void)addTween:(GTween*)tween;
- (void)removeTween:(GTween *)tween;

@end

@implementation GTweenManager {
    NSTimer         *_timer;
    NSMutableArray  *_tweens;
}

static id _defaultManager;
+ (id)instance
{
    if (_defaultManager) {
        return _defaultManager;
    }else {
        @synchronized([self class]) {
            _defaultManager = [[self alloc] init];
        }
    }
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tweens = [NSMutableArray new];
    }
    return self;
}

- (void)checkTimer
{
    if (!_timer || !_timer.isValid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1/frameRace
                                                  target:self
                                                selector:@selector(update)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (NSArray*)tweens
{
    return [_tweens copy];
}

- (void)addTween:(GTween *)tween
{
    [self checkTimer];
    [_tweens addObject:tween];
}
- (void)removeTween:(GTween *)tween
{
    [_tweens removeObject:tween];
}

- (void)update
{
    NSArray *array = [_tweens copy];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GTween *tween = obj;
        if (![tween update]) {
            [_tweens removeObject:tween];
        }
    }];
    if (_tweens.count == 0) {
        [_timer invalidate];
    }
}

@end

@implementation GTween{
@protected
    GTweenStatus    _status;
    NSMutableArray  *_properties;
    int     _frame,
            _totalFrame;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _onUpdate = [[GCallback alloc] init];
        _onComplete = [[GCallback alloc] init];
        _properties = [NSMutableArray array];
    }
    return self;
}

- (id)initWithTarget:(id)target duration:(NSTimeInterval)duration ease:(id)ease
{
    self = [self init];
    if (self) {
        _target = target;
        _duration = duration;
        _ease = ease;
    }
    return self;
}

+ (id)tween:(id)target duration:(NSTimeInterval)duration ease:(GEase *)ease
{
    return [[self alloc] initWithTarget:target
                               duration:duration
                                   ease:ease];
}

- (NSArray *)properties
{
    return [_properties copy];
}

- (void)initializeTween
{
    _totalFrame = (int)(_duration*frameRace);
    _frame = 0;
}

- (void)start
{
    if (_status == GTweenStatusNoStart) {
        [self initializeTween];
        _status = GTweenStatusProgress;
        [[GTweenManager instance] addTween:self];
    }
    if (_status == GTweenStatusPaused) {
        _status = GTweenStatusProgress;
        [[GTweenManager instance] addTween:self];
    }
}

- (void)pause
{
    if (_status == GTweenStatusProgress) {
        _status = GTweenStatusPaused;
        [[GTweenManager instance] removeTween:self];
    }
}

- (void)stop
{
    if (_status == GTweenStatusPaused || _status == GTweenStatusProgress) {
        _status = GTweenStatusStop;
        [[GTweenManager instance] removeTween:self];
    }
}

- (void)reset
{
    [self initializeTween];
    _status = GTweenStatusNoStart;
    [[GTweenManager instance] removeTween:self];
}

- (BOOL)update
{
    _frame ++;
    if (_frame >= _totalFrame) {
        float p = [self.ease ease:1];
        [_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj progress:p target:_target];
        }];
        [self.onUpdate invoke];
        if (self.isLoop) {
            return YES;
        }else {
            [self.onComplete invoke];
            _status = GTweenStatusStop;
            return NO;
        }
    }else {
        float p = [self.ease ease:_frame/(float)_totalFrame];
        [_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj progress:p target:_target];
        }];
        [self.onUpdate invoke];
        return YES;
    }
}

- (void)addProperty:(GTweenProperty *)property
{
    [_properties addObject:property];
}

@end

@implementation GTweenChain{
    NSMutableArray *_tweens;
    int _tweenIndex;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tweens = [NSMutableArray new];
    }
    return self;
}

+ (id)tweenChain
{
    return [[self alloc] init];
}

- (NSArray*)tweens
{
    return [_tweens copy];
}

- (void)initializeTween
{
    _tweenIndex = 0;
    [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj initializeTween];
    }];
}

- (void)addTween:(GTween *)tween
{
    [_tweens addObject:tween];
}

- (void)start
{
    [super start];
}

- (void)reset
{
    [super reset];
    [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj reset];
    }];
}

- (BOOL)update
{
    if (_tweenIndex >= _tweens.count) {
        _status = GTweenStatusStop;
        _tweenIndex = 0;
        [self.onComplete invoke];
        return NO;
    }else {
        GTween *tween = [_tweens objectAtIndex:_tweenIndex];
        if (![tween update]) {
            _tweenIndex += 1;
            if (_tweenIndex >= _tweens.count && self.isLoop) {
                _tweenIndex %= _tweens.count;
            }
            if (_tweenIndex < _tweens.count) {
                tween = [_tweens objectAtIndex:_tweenIndex];
                [tween reset];
            }else {
                [self.onComplete invoke];
                return NO;
            }
        }
        return YES;
    }
}

@end

