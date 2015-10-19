//
//  ViewController.m
//  JC_TouchViewDemo
//
//  Created by JohnsonChou on 15/10/19.
//  Copyright © 2015年 Tapole. All rights reserved.
//

#import "ViewController.h"

#import "JC_TouchView.h"

@interface ViewController ()<JCTouchViewDelegate>

@property (nonatomic,strong) UIView * redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JC_TouchView * touchView = [JC_TouchView new];
    touchView.frame = self.view.bounds;
    touchView.delegate = self;
    touchView.backgroundColor = [UIColor lightGrayColor];
    [touchView tapClickBlock:^{
        NSLog(@"111");
    }];
    [self.view addSubview:touchView];
    
    self.redView = [UIView new];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.bounds = CGRectMake(0, 0, 200, 100);
    self.redView.center = self.view.center;
    self.redView.userInteractionEnabled = NO;
    [self.view addSubview:self.redView];

}

#pragma mark - delegaate methods
-(void)touchView:(JC_TouchView *)touchView PanClickWithThePoint:(CGPoint)point
{
    self.redView.center = CGPointMake(self.redView.center.x + point.x,
                                      self.redView.center.y + point.y);
}
-(void)touchView:(JC_TouchView *)touchView PinchClickWithTheScale:(CGFloat)scale
{
    self.redView.transform = CGAffineTransformScale(self.redView.transform,
                                                    scale,
                                                    scale);
}
-(void)touchView:(JC_TouchView *)touchView RotateClickWithTheRotation:(CGFloat)rotation
{
    self.redView.transform = CGAffineTransformRotate(self.redView.transform,
                                                     rotation);
}

@end
