# carouselImages
![轮播图](http://raw.github.com/nuoyaneasy/carouselImages/master/screenshots/轮播图.gif)

轮播图，主要学习NSTimer，NSRunLoop以及UIScrollView。
在三者的配合下，来实现轮播效果。
学习到了NSTimer的实例化，自动添加或者手动添加到NSRunLoop中。
UIScrollView以及UIPageControl的代理方法，以及两者之间如何同步。
同时通过对NSTimer实例对象的invalidate方法，达到UIScrollView在被拖拽时候，移出NSTimer取消滚动，在拖拽取消时候，重新实例一个NSTimer对象，进行轮播。
