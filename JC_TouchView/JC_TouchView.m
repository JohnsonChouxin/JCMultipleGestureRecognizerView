//
//  JC_TouchView.m
//  TouchDemo
//
//  Created by JohnsonChou on 15/10/17.
//  Copyright © 2015年 Tapole. All rights reserved.
//
#define radiansToDegrees(x) (180.0 * x / M_PI)

#import "JC_TouchView.h"

@interface JC_TouchView ()
// 手指数
@property (nonatomic,assign) NSInteger fingerNumber;
// 第一根手指
@property (nonatomic,strong) UITouch * firstFingerTouch;
// 第二根手指
@property (nonatomic,strong) UITouch * secondFingerTouch;
// 最近一次两指间距离
@property (nonatomic,assign) CGFloat initialValue;
// 形变量
@property (nonatomic,assign) CGFloat scale;
// 最近一次偏移角度
@property (nonatomic,assign) CGFloat rotation;
// 最近一次第一个触碰点
@property (nonatomic,assign) CGPoint thePoint;
// 点击事件
@property (nonatomic,copy) void(^ tapClickBlock)();

@property (nonatomic,assign) CGFloat scaleValue;

@property (nonatomic,assign) CGFloat rotationValue;

@end

@implementation JC_TouchView

-(void)dealloc
{
    self.delegate = nil;
    self.tapClickBlock = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.multipleTouchEnabled = YES;
        
        self.initialValue = 0 ;
        
        self.scale = 1.0f;
    }
    return self;
}
-(void)tapClickBlock:(void (^)())eventBlock
{
    self.tapClickBlock = eventBlock;
}
-(CGFloat)getScale
{
    return self.scaleValue;
}
-(CGFloat)getRotation
{
    return self.rotationValue;
}


-(CGFloat)getTheLineBetweenPotin:(CGPoint)pointOne andPoint:(CGPoint)pointTwo
{
    CGFloat lineWidth,lineOne,lineTwo;
    
    lineOne = pow(fabs(pointOne.x - pointTwo.x), 2);
    
    lineTwo = pow(fabs(pointOne.y - pointTwo.y), 2);
    
    lineWidth = sqrt(lineOne + lineTwo);
    
    return lineWidth;
}
-(CGFloat)getTheRotationBetweenTwoPoint:(CGPoint)pointOne andPointTwo:(CGPoint)pointTwo
{
    CGPoint point1 = pointOne;
    CGPoint point2 = pointTwo;
    
    CGFloat value = atan2((point2.y-point1.y), (point2.x-point1.x));
    
    return value;
}
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    
    CGFloat height = second.y - first.y;
    
    CGFloat width = first.x - second.x;
    
    CGFloat rads = atan(height/width);
    
    return radiansToDegrees(rads);
}

-(void)CGAffineTransformScale
{
    CGFloat lineWidth = [self getTheLineBetweenPotin:[self.firstFingerTouch locationInView:self] andPoint:[self.secondFingerTouch locationInView:self]];
    
    CGFloat scaleNew = lineWidth/self.initialValue;
    
    if ([self.delegate respondsToSelector:@selector(touchView:PinchClickWithTheScale:)]) {
        [self.delegate touchView:self PinchClickWithTheScale:scaleNew];
    }
    
    self.initialValue = lineWidth;
}

-(void)CGAffineTransformRotate
{
    CGPoint point1 = [self.firstFingerTouch locationInView:self];
    CGPoint point2 = [self.secondFingerTouch locationInView:self];
    
    CGFloat rotation = angleBetweenPoints(point1, point2);
    
    CGFloat rotationPass;
    
    if (((rotation - self.rotation)<-170) || ((rotation - self.rotation) > 170)) {
        rotationPass = -(rotation + self.rotation)/50.0;
    }else{
        rotationPass = -(rotation - self.rotation)/50.0;
    }
    
    if ([self.delegate respondsToSelector:@selector(touchView:RotateClickWithTheRotation:)]) {
        [self.delegate touchView:self RotateClickWithTheRotation:rotationPass];
    }
    
    self.rotation = rotation;
}
-(void)CGAffineTransformMove
{
    CGPoint nextPoint = [self.firstFingerTouch locationInView:self];
    
    CGFloat width = nextPoint.x - self.thePoint.x;
    CGFloat height = nextPoint.y - self.thePoint.y;
    
    self.thePoint = nextPoint;
    
    if ([self.delegate respondsToSelector:@selector(touchView:PanClickWithThePoint:)]) {
        [self.delegate touchView:self PanClickWithThePoint:CGPointMake(width, height)];
    }
}
-(void)CGAffineTransformMoveForTwoFinger
{
    CGPoint nextPoint1 = [self.firstFingerTouch locationInView:self];
    CGPoint nextPoint2 = [self.secondFingerTouch locationInView:self];
    
    CGFloat x = (nextPoint1.x > nextPoint2.x)?nextPoint2.x:nextPoint1.x;
    CGFloat y = (nextPoint1.y > nextPoint2.y)?nextPoint2.y:nextPoint1.y;
    
    CGPoint thisPoint = CGPointMake((fabs(nextPoint1.x - nextPoint2.x)/2.0)+x, (fabs(nextPoint1.y - nextPoint2.y)/2.0)+y);
    
    CGPoint movePoint = CGPointMake((thisPoint.x - self.thePoint.x), (thisPoint.y-self.thePoint.y));
    
    if ([self.delegate respondsToSelector:@selector(touchView:PanClickWithThePoint:)]) {
        [self.delegate touchView:self PanClickWithThePoint:movePoint];
    }
    
    self.thePoint = thisPoint;
}
// ==========================================================================================
// 开始
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 0) {
        return;
    }
    
    if (self.fingerNumber > 2) {
        return;
    }
    
    for (UITouch * touch in touches) {
        self.fingerNumber ++;
        
        if (self.fingerNumber == 1) {
            self.firstFingerTouch = touch;
            
            self.thePoint = [self.firstFingerTouch locationInView:self];
        }
        
        if (self.fingerNumber == 2) {
            self.secondFingerTouch = touch;
            
            CGPoint point1 = [self.firstFingerTouch locationInView:self];
            CGPoint point2 = [self.secondFingerTouch locationInView:self];
            
            self.initialValue = [self getTheLineBetweenPotin:[self.firstFingerTouch locationInView:self] andPoint:[self.secondFingerTouch locationInView:self]];
            
            self.rotation = angleBetweenPoints(point1, point2);
            
            CGFloat x = (point1.x > point2.x)?point2.x:point1.x;
            CGFloat y = (point1.y > point2.y)?point2.y:point1.y;
            
            self.thePoint = CGPointMake((fabs(point1.x - point2.x)/2.0)+x, (fabs(point1.y - point2.y)/2.0)+y);
        }
        
        if (self.fingerNumber > 2) {
        }
    }
}
// 移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.firstFingerTouch == nil && self.secondFingerTouch == nil) {
        return;
    }
    
    if (self.firstFingerTouch !=nil && self.secondFingerTouch !=nil) {
        [self CGAffineTransformScale];
        
        [self CGAffineTransformRotate];
        
        [self CGAffineTransformMoveForTwoFinger];
    }
    
    if (self.firstFingerTouch != nil && self.secondFingerTouch == nil) {
        [self CGAffineTransformMove];
    }
}
// 结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        self.fingerNumber --;
        
        if (touch == self.firstFingerTouch || touch == self.secondFingerTouch) {
            if (touch == self.firstFingerTouch) {
                
                if (self.firstFingerTouch.tapCount == 1) {
                    if (self.tapClickBlock) {
                        self.tapClickBlock();
                    }
                }
                
                self.firstFingerTouch = nil;
                
                if (self.secondFingerTouch != nil) {
                    self.firstFingerTouch = self.secondFingerTouch;
                    self.secondFingerTouch = nil;
                }
            }
            
            if (touch == self.secondFingerTouch) {
                self.secondFingerTouch = nil;
            }
        }
    }
    
    if (self.firstFingerTouch != nil) {
        if (self.secondFingerTouch != nil) {
            CGPoint nextPoint1 = [self.firstFingerTouch locationInView:self];
            CGPoint nextPoint2 = [self.secondFingerTouch locationInView:self];
            
            CGFloat x = (nextPoint1.x > nextPoint2.x)?nextPoint2.x:nextPoint1.x;
            CGFloat y = (nextPoint1.y > nextPoint2.y)?nextPoint2.y:nextPoint1.y;
            
            self.thePoint = CGPointMake((fabs(nextPoint1.x - nextPoint2.x)/2.0)+x, (fabs(nextPoint1.y - nextPoint2.y)/2.0)+y);
        }else{
            self.thePoint = [self.firstFingerTouch locationInView:self];
        }
    }
}
// ==========================================================================================
@end