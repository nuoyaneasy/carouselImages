//
//  ViewController.m
//  图片轮播
//
//  Created by Yang Chao on 6/30/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ViewController.h"
#define kImageCount 5
@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

#pragma mark - accessors

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 130)];
        [self.view addSubview:_scrollView];
    }
    //contentSize
    _scrollView.contentSize = CGSizeMake(kImageCount * _scrollView.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = kImageCount;
        CGSize size = [_pageControl sizeForNumberOfPages:kImageCount];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.center.x, 130);
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    }
    return _pageControl;
}

#pragma mark - system Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self setupSrollingImageViews];
    
    [self setupPageControl];
    
    [self startTimer];
}

#pragma mark - setup methods

- (void)setupSrollingImageViews
{
    //设置图片
    NSUInteger count = kImageCount;
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_%02d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = image;
        [self.scrollView addSubview:imageView];
    }
    
    //计算imageView的位置
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        //调整 x => origin => frame
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        imageView.frame = frame;
    }];
}

- (void)setupPageControl
{
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}
/**
 *  分页控件监听方法
 */
- (void)pageChanged:(UIPageControl *)pageControl
{
    //根据页数，调整滚动视图中的图片位置 contentOffset
    CGFloat x = pageControl.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)startTimer
{
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer
{
    //页号发生变化
    //（当前的页数 + 1） % 总页数
    int page = (self.pageControl.currentPage + 1) % kImageCount;
    self.pageControl.currentPage = page;
    //直接调用监听方法
    [self pageChanged:self.pageControl];
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
//    NSLog(@"%d",page);
//    self.pageControl.currentPage = page;
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = self.scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

@end
