//
//  JCMultipleGestureRecognizer.m
//  JC_TouchViewDemo
//
//  Created by JohnsonChou on 15/10/29.
//  Copyright © 2015年 Tapole. All rights reserved.
//
#define radiansToDegrees(x) (180.0 * x / M_PI)


#import "JCMultipleGestureRecognizerView.h"

@interface JCMultipleGestureRecognizerView ()
// 手指数
@property (nonatomic,assign) NSInteger fingerNumber;
// 第一根手指
@property (nonatomic,strong) UITouch   * firstFingerTouch;
// 第二根手指
@property (nonatomic,strong) UITouch   * secondFingerTouch;
// 最近一次两指间距离
@property (nonatomic,assign) CGFloat   initialValue;
// 形变量
@property (nonatomic,assign) CGFloat   scale;
// 最近一次偏移角度
@property (nonatomic,assign) CGFloat   rotation;
// 最近一次第一个触碰点
@property (nonatomic,assign) CGPoint   thePoint;
// 缩放总倍数
@property (nonatomic,assign) CGFloat   scaleValue;
// 旋转总度数
@property (nonatomic,assign) CGFloat   rotationValue;

@end

@implementation JCMultipleGestureRecognizerView

-(void)dealloc
{
    self.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.multipleTouchEnabled = YES;
        
        self.initialValue = 0 ;
        
        self.scale = 1.0f;
        
        self.scaleValue = 1.0f;
        
        self.rotationValue = 0.0f;
    }
    return self;
}

-(CGFloat)getTheTotalScale
{
    return self.scaleValue;
}

-(CGFloat)getTheTotalRotation
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
    
    self.scaleValue *= scaleNew;
    
    if ([self.delegate respondsToSelector:@selector(JCMultipleGestureRecognizerView:PinchClickWithTheScale:)]) {
        [self.delegate JCMultipleGestureRecognizerView:self PinchClickWithTheScale:scaleNew];
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
    
    self.rotationValue += rotationPass;
    
    if ([self.delegate respondsToSelector:@selector(JCMultipleGestureRecognizerView:RotateClickWithTheRotation:)]) {
        [self.delegate JCMultipleGestureRecognizerView:self RotateClickWithTheRotation:rotationPass];
    }
    
    self.rotation = rotation;
}
-(void)CGAffineTransformMove
{
    CGPoint nextPoint = [self.firstFingerTouch locationInView:self];
    
    CGFloat width = nextPoint.x - self.thePoint.x;
    CGFloat height = nextPoint.y - self.thePoint.y;
    
    self.thePoint = nextPoint;
    
    if ([self.delegate respondsToSelector:@selector(JCMultipleGestureRecognizerView:PanClickWithThePoint:)]) {
        [self.delegate JCMultipleGestureRecognizerView:self PanClickWithThePoint:CGPointMake(width, height)];
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
    
    if ([self.delegate respondsToSelector:@selector(JCMultipleGestureRecognizerView:PanClickWithThePoint:)]) {
        [self.delegate JCMultipleGestureRecognizerView:self PanClickWithThePoint:movePoint];
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
                    if ([self.delegate respondsToSelector:@selector(JCMultipleGestureRecognizerViewClickWithTap:)]) {
                        [self.delegate JCMultipleGestureRecognizerViewClickWithTap:self];
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