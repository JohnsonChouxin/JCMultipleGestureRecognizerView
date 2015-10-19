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

##如果你不会用的话<br>
   这里是我的简书博客 [this is blog](http://www.jianshu.com/p/59224648828b#)<br>

##I am JohnsonChouxin
  * [This is my Blog](http://www.jianshu.com/users/91577acf333a/latest_articles)<br>
  * 欢迎与我交流，谢谢您的宝贵意见。
