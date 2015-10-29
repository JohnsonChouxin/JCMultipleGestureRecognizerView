//
//  ViewController.m
//  JCMultipleGestureRecognizerViewDemo
//
//  Created by JohnsonChou on 15/10/19.
//  Copyright © 2015年 Tapole. All rights reserved.
//

#import "ViewController.h"

#import "JCMultipleGestureRecognizerView.h"

@interface ViewController ()<JCMultipleGestureRecognizerDelegate>

@property (nonatomic,strong) UIView * redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JCMultipleGestureRecognizerView * touchView = [JCMultipleGestureRecognizerView new];
    touchView.frame = self.view.bounds;
    touchView.delegate = self;
    touchView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:touchView];
    
    self.redView = [UIView new];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.bounds = CGRectMake(0, 0, 200, 100);
    self.redView.center = self.view.center;
    self.redView.userInteractionEnabled = NO;
    [self.view addSubview:self.redView];

}

#pragma mark - delegaate methods
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
                  PanClickWithThePoint:(CGPoint)point
{
    self.redView.center = CGPointMake(self.redView.center.x + point.x,
                                      self.redView.center.y + point.y);
}
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
                PinchClickWithTheScale:(CGFloat)scale
{
    self.redView.transform = CGAffineTransformScale(self.redView.transform,
                                                    scale,
                                                    scale);
}
-(void)JCMultipleGestureRecognizerView:(JCMultipleGestureRecognizerView *)touchView
            RotateClickWithTheRotation:(CGFloat)rotation
{
    self.redView.transform = CGAffineTransformRotate(self.redView.transform,
                                                     rotation);
}
-(void)JCMultipleGestureRecognizerViewClickWithTap:(JCMultipleGestureRecognizerView *)touchView
{
    NSLog(@"%@",touchView);
}

@end
