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
    GTweenStatusPlayForword,
    GTweenStatusPlayBackword,
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
// Play Backword
- (void)backword;

// need override
// Call before not play to start play.
- (void)initializeTween:(BOOL)forword;

@end

@interface GTweenChain : GTween

@property (nonatomic, readonly) NSArray *tweens;

+ (id)tweenChain;
- (void)addTween:(GTween*)tween;

@end

@interface GTween (GTweenProperty)

- (id)floatPro:(NSString *)name from:(CGFloat)from to:(CGFloat)to;
- (id)floatPro:(NSString *)name to:(CGFloat)to;

- (id)rectPro:(NSString *)name from:(CGRect)from to:(CGRect)to;
- (id)rectPro:(NSString *)name to:(CGRect)to;

- (id)sizePro:(NSString *)name from:(CGSize)from to:(CGSize)to;
- (id)sizePro:(NSString *)name to:(CGSize)to;

- (id)pointPro:(NSString *)name from:(CGPoint)from to:(CGPoint)to;
- (id)pointPro:(NSString *)name to:(CGPoint)to;

- (id)transformPro:(NSString *)name from:(CATransform3D)from to:(CATransform3D)to;
- (id)transformPro:(NSString *)name to:(CATransform3D)to;

- (id)rotationPro:(NSString *)name from:(CGFloat)from to:(CGFloat)to;


- (id)colorPro:(NSString *)name from:(UIColor*)from to:(UIColor*)to;
- (id)colorPro:(NSString *)name to:(UIColor*)to;

@end