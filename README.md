GTween
======

A lightweight tween library for iOS. Ease functions from [tween.js](https://github.com/sole/tween.js)

======

![Screen shoot](https://github.com/dbsGen/GTween/raw/master/Images/record1.gif)
![Screen shoot](https://github.com/dbsGen/GTween/raw/master/Images/record2.gif)

Usage
=======

    GTween *tween = [GTween tween:view
                         duration:1
                             ease:[GEaseBackOut class]];
    [tween pointPro:@"center"
                 to:CGPointMake(180, 250)];
    [tween start];

