//
//  JCMultipleGestureRecognizer.h
//  JC_TouchViewDemo
//
//  Created by JohnsonChou on 15/10/29.
//  Copyright © 2015年 Tapole. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCMultipleGestureRecognizerView;

@protocol JCMultipleGestureRecognizerDelegate <NSObject>
/**
 *  拖动 Touch ,支持单指和双指拖动。
 *
 *  @param touchView 响应 View
 *  @param point     在X、Y方向上拖动距离组成的 point
 */
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
                  PanClickWithThePoint:(CGPoint)point;




/**
 *  缩放 Touch
 *
 *  @param touchView 响应 View
 *  @param scale     缩放倍数
 */
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
                PinchClickWithTheScale:(CGFloat)scale;




/**
 *  旋转 Touch
 *
 *  @param touchView 响应 View
 *  @param rotation  旋转角度
 */
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
            RotateClickWithTheRotation:(CGFloat)rotation;




/**
 *  点击 Touch
 *
 *  @param touchView 响应 View
 */
-(void)JCMultipleGestureRecognizerViewClickWithTap:(JCMultipleGestureRecognizerView *)touchView;
@end




@interface JCMultipleGestureRecognizerView : UIView
// 代理
@property (nonatomic,weak) id<JCMultipleGestureRecognizerDelegate> delegate;





/**
 *  获取总缩放倍数
 *
 *  @return 总缩放倍数
 */
-(CGFloat)getTheTotalScale;





/**
 *  获取总的旋转度数
 *
 *  @return 总旋转度数
 */
-(CGFloat)getTheTotalRotation;

@end
