//
//  JC_TouchView.h
//  TouchDemo
//
//  Created by JohnsonChou on 15/10/17.
//  Copyright © 2015年 Tapole. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JC_TouchView;

@protocol JCTouchViewDelegate <NSObject>
-(void)touchView:(JC_TouchView *)touchView PanClickWithThePoint:(CGPoint)point;

-(void)touchView:(JC_TouchView *)touchView PinchClickWithTheScale:(CGFloat)scale;

-(void)touchView:(JC_TouchView *)touchView RotateClickWithTheRotation:(CGFloat)rotation;
@end

@interface JC_TouchView : UIView

@property (nonatomic,weak) id<JCTouchViewDelegate> delegate;

-(void)tapClickBlock:(void (^)())eventBlock;

-(CGFloat)getScale;

-(CGFloat)getRotation;

@end
