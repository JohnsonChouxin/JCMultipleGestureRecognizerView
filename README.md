# JCMultipleGestureRecognizerView
这是一个组合了缩放、旋转、点击、单指拖动、双指拖动的View.<br>
它能识别你的复杂手势，分解成缩放和旋转、拖动（单指和双指）。通过一些算法来计算当前手势的缩放指令、旋转指令、拖动指令，并且通过代理的形式给予响应。
# Use
<pre><code>
JCMultipleGestureRecognizerView * touchView = [JCMultipleGestureRecognizerView new];
    touchView.frame = self.view.bounds;
    touchView.delegate = self;
    touchView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:touchView];
    
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
    
    
    </code></pre>
    
# effect
![](https://github.com/JohnsonChouxin/JCTouchView/raw/master/Ges2.gif)

##如果你不会用的话<br>
   这里是我的简书博客 [this is blog](http://www.jianshu.com/p/59224648828b#)<br>

##I am JohnsonChouxin
  * [This is my Blog](http://www.jianshu.com/users/91577acf333a/latest_articles)<br>
  * 欢迎与我交流，谢谢您的宝贵意见。
