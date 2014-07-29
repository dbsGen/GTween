//
//  GTween.m
//  GTween
//
//  Created by zrz on 14-7-27.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "GTween.h"
#import <objc/runtime.h>

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

- (BOOL)isOver
{
    return _status == GTweenStatusStop;
}

- (float)currentPercent
{
    return _frame/(float)_totalFrame;
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

- (void)initializeTween:(BOOL)forword
{
    if (forword) {
        _totalFrame = (int)(_duration*frameRace);
        _frame = 0;
    }else {
        _totalFrame = (int)(_duration*frameRace);
        _frame = _totalFrame;
    }
}

- (void)start
{
    if (_status == GTweenStatusNoStart) {
        [self initializeTween:true];
        _status = GTweenStatusPlayForword;
        [[GTweenManager instance] addTween:self];
    }
    if (_status == GTweenStatusPaused) {
        _status = GTweenStatusPlayForword;
        [[GTweenManager instance] addTween:self];
    }
    if (_status == GTweenStatusPlayBackword) {
        _status = GTweenStatusPlayForword;
    }
}

- (void)backword
{
    if (_status == GTweenStatusNoStart) {
        [self initializeTween:false];
        _status = GTweenStatusPlayBackword;
        [[GTweenManager instance] addTween:self];
    }
    if (_status == GTweenStatusPaused) {
        _status = GTweenStatusPlayBackword;
        [[GTweenManager instance] addTween:self];
    }
    if (_status == GTweenStatusPlayForword) {
        _status = GTweenStatusPlayBackword;
    }
}

- (void)pause
{
    if (_status == GTweenStatusPlayForword ||
        _status == GTweenStatusPlayBackword) {
        _status = GTweenStatusPaused;
        [[GTweenManager instance] removeTween:self];
    }
}

- (void)stop
{
    if (_status == GTweenStatusPaused ||
        _status == GTweenStatusPlayForword ||
        _status == GTweenStatusPlayBackword) {
        _status = GTweenStatusStop;
        [[GTweenManager instance] removeTween:self];
    }
}

- (void)reset
{
    _status = GTweenStatusNoStart;
    [[GTweenManager instance] removeTween:self];
}

- (BOOL)update
{
    BOOL check, isForword;
    if (_status == GTweenStatusPlayForword) {
        _frame ++;
        check = _frame >= _totalFrame;
        isForword = true;
    }else if (_status == GTweenStatusPlayBackword) {
        _frame --;
        check = _frame < 0;
        isForword = false;
    }else {
        return NO;
    }
    if (check) {
        float p = [self.ease ease:isForword ? 1 : 0];
        [_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj progress:p target:_target];
        }];
        [self.onUpdate invoke];
        if (self.isLoop) {
            [self initializeTween:isForword];
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

- (void)initializeTween:(BOOL)forword
{
    if (forword) {
        _tweenIndex = 0;
        [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj initializeTween:(BOOL)forword];
            ((GTween*)obj)->_status = GTweenStatusPlayForword;
        }];
    }else {
        _tweenIndex = (int)_tweens.count - 1;
        [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj initializeTween:(BOOL)forword];
            ((GTween*)obj)->_status = GTweenStatusPlayBackword;
        }];
    }
}

- (void)start
{
    [super start];
    [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(GTween*)obj start];
    }];
}

- (void)backword
{
    [super backword];
    [_tweens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj backword];
    }];
}

- (void)addTween:(GTween *)tween
{
    [_tweens addObject:tween];
}

- (BOOL)update
{
    BOOL check, isForword;
    if (_status == GTweenStatusPlayForword) {
        check = _tweenIndex >= _tweens.count;
        isForword= true;
    }else if (_status == GTweenStatusPlayBackword) {
        check = _tweenIndex < 0;
        isForword = false;
    }else return NO;
    if (check) {
        _status = GTweenStatusStop;
        [self.onComplete invoke];
        return NO;
    }else {
        GTween *tween = [_tweens objectAtIndex:_tweenIndex];
        if (![tween update]) {
            _tweenIndex += isForword ? 1 : -1;
            if (_tweenIndex >= _tweens.count && self.isLoop) {
                _tweenIndex %= _tweens.count;
            }
            if (_tweenIndex < _tweens.count && _tweenIndex >= 0) {
                tween = [_tweens objectAtIndex:_tweenIndex];
                [tween initializeTween:isForword];
                tween->_status = isForword ? GTweenStatusPlayForword:GTweenStatusPlayBackword;
            }else {
                _status = GTweenStatusStop;
                [self.onComplete invoke];
                return NO;
            }
        }
        return YES;
    }
}

@end


@implementation GTween (GTweenProperty)
#define GTGetter(TYPE, NAME) ({\
    SEL sel = sel_registerName([NAME cStringUsingEncoding:NSUTF8StringEncoding]);\
    Method method = class_getInstanceMethod([self.target class], sel);\
    TYPE(*imp)(id, SEL) = (TYPE(*)(id, SEL))method_getImplementation(method);\
    imp(self.target, sel);\
})

- (id)floatPro:(NSString *)name from:(CGFloat)from to:(CGFloat)to
{
    [self addProperty:[GTweenFloatProperty property:name
                                               from:from
                                                 to:to]];
    return self;
}

- (id)floatPro:(NSString *)name to:(CGFloat)to
{
    [self floatPro:name
              from:GTGetter(float, name)
                to:to];
    return self;
}

- (id)rectPro:(NSString *)name from:(CGRect)from to:(CGRect)to
{
    [self addProperty:[GTweenCGRectProperty property:name
                                                from:from
                                                  to:to]];
    return self;
}

- (id)rectPro:(NSString *)name to:(CGRect)to
{
    
    [self rectPro:name
             from:GTGetter(CGRect, name)
               to:to];
    return self;
}

- (id)sizePro:(NSString *)name from:(CGSize)from to:(CGSize)to
{
    [self addProperty:[GTweenCGSizeProperty property:name
                                                from:from
                                                  to:to]];
    return self;
}

- (id)sizePro:(NSString *)name to:(CGSize)to
{
    [self sizePro:name
             from:GTGetter(CGSize, name)
               to:to];
    return self;
}

- (id)pointPro:(NSString *)name from:(CGPoint)from to:(CGPoint)to
{
    [self addProperty:[GTweenCGPointProperty property:name
                                                 from:from
                                                   to:to]];
    return self;
}

- (id)pointPro:(NSString *)name to:(CGPoint)to
{
    return [self pointPro:name
                     from:GTGetter(CGPoint, name)
                       to:to];
}

- (id)transformPro:(NSString *)name from:(CATransform3D)from to:(CATransform3D)to
{
    [self addProperty:[GTweenCATransform3DProperty property:name
                                                       from:from
                                                         to:to]];
    return self;
}
- (id)transformPro:(NSString *)name to:(CATransform3D)to
{
    return [self transformPro:name
                         from:GTGetter(CATransform3D, name)
                           to:to];
}

- (id)rotationPro:(NSString *)name from:(CGFloat)from to:(CGFloat)to
{
    [self addProperty:[GTweenRotationProperty property:name
                                                  from:from
                                                    to:to]];
    return self;
}

- (id)colorPro:(NSString *)name from:(UIColor *)from to:(UIColor *)to
{
    [self addProperty:[GTweenColorProperty property:name
                                               from:from
                                                 to:to]];
    return self;
}

- (id)colorPro:(NSString *)name to:(UIColor *)to
{
    return [self colorPro:name
                     from:GTGetter(UIColor*, name)
                       to:to];
}

@end

