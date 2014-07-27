//
//  GTween.h
//  GTween
//
//  Created by zrz on 14-7-27.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTweenProperty.h"
#import "GCallback.h"
#import "GEase.h"

typedef enum : NSUInteger {
    GTweenStatusNoStart,
    GTweenStatusProgress,
    GTweenStatusPaused,
    GTweenStatusStop
} GTweenStatus;

@interface GTween : NSObject

@property (nonatomic, readonly) id          target;
@property (nonatomic, readonly) NSArray     *properties;
@property (nonatomic, readonly) CGFloat     currentPercent;
@property (nonatomic, readonly) BOOL        isOver;
@property (nonatomic, readonly) id          ease;
@property (nonatomic, readonly) GTweenStatus    status;
@property (nonatomic, readonly) NSTimeInterval  duration;

// events
@property (nonatomic, readonly) GCallback   *onComplete;
@property (nonatomic, readonly) GCallback   *onUpdate;

// settings
@property (nonatomic) BOOL isLoop;

- (id)initWithTarget:(id)target duration:(NSTimeInterval)duration ease:(id)ease;

+ (id)tween:(id)target duration:(NSTimeInterval)duration ease:(id)ease;
- (void)addProperty:(GTweenProperty*)property;

- (void)start;
- (void)pause;
- (void)stop;
- (void)reset;

// need override
- (void)initializeTween;

@end

@interface GTweenChain : GTween

@property (nonatomic, readonly) NSArray *tweens;

+ (id)tweenChain;
- (void)addTween:(GTween*)tween;

@end