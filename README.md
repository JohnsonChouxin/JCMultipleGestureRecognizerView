# JCTouchView
这是一个组合了缩放、旋转、点击、单指拖动、双指拖动的自定义View

# Use
<pre><code>
JC_TouchView * touchView = [JC_TouchView new];
    touchView.frame = self.view.bounds;
    touchView.delegate = self;
    touchView.backgroundColor = [UIColor lightGrayColor];
    [touchView tapClickBlock:^{
        NSLog(@"JC_TouchView");
    }];
    [self.view addSubview:touchView];
    </code></pre>
    
# effect
![](https://github.com/JohnsonChouxin/JCTouchView/raw/master/Ges2.gif)
