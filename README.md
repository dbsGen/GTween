GTween
======

A lightweight tween library for iOS. Ease functions from [tween.js](https://github.com/sole/tween.js)

======

![Screen shoot](http://i1368.photobucket.com/albums/ag167/dbsGen/gifs_zps6ea64ac6.gif)

Usage
=======

    GTween *tween = [GTween tween:view
                         duration:1
                             ease:[GEaseBackOut class]];
    [tween pointPro:@"center"
                 to:CGPointMake(180, 250)];
    [tween start];

[Blog link(Chinese)](http://zhaorenzhi.cn/articles/53d5256961192cd8c9000004)
