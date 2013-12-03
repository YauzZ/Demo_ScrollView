//
//  ViewController.m
//  Demo_ScrollView
//
//  Created by YauzZ on 3/12/13.
//  Copyright (c) 2013年 YauzZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL _isEdge;
}

@property (strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIPanGestureRecognizer *singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:singlePan];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"world.jpg"]];
    [_scrollView addSubview:imageView];
    _scrollView.contentSize = imageView.bounds.size;
    
    UIPanGestureRecognizer *singlePanS = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanS:)];
    singlePanS.delegate = (id)self;
    [_scrollView addGestureRecognizer:singlePanS];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.view];
      NSLog(@"%@",[NSValue valueWithCGPoint:translation]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)handlePanS:(UIPanGestureRecognizer *)sender
{
    UIScrollView *scrollView = (UIScrollView *)sender.view;
    static CGPoint originPoint;
    if (sender.state == UIGestureRecognizerStateBegan) {
        originPoint = scrollView.contentOffset;
        return;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
//        _isEdge = NO;
        return;
    }
    
    CGPoint translation = [sender translationInView:self.scrollView];
    CGPoint destPoint = CGPointMake(originPoint.x - translation.x, originPoint.y - translation.y);
    
    if (destPoint.x < 0) {
        destPoint.x = 0;
        _isEdge = YES;
    }
    
    if (destPoint.y < 0) {
        destPoint.y = 0;
        _isEdge = YES;
    }
    
    if ((destPoint.x + 320) > _scrollView.contentSize.width) {
        destPoint.x = _scrollView.contentSize.width - 320;
        _isEdge = YES;
    }
    
    if ((destPoint.y + 480) > _scrollView.contentSize.height ) {
        destPoint.y = _scrollView.contentSize.height - 480;
        _isEdge = YES;
    }
    
    _scrollView.contentOffset = destPoint;
    
    NSLog(@"scrollView %@",[NSValue valueWithCGPoint:scrollView.contentOffset]);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ( (_scrollView.contentOffset.x <= 0 || _scrollView.contentOffset.y <= 0 || (_scrollView.contentOffset.x + 320) >= _scrollView.contentSize.width || (_scrollView.contentOffset.y + 480) >= _scrollView.contentSize.height) && _isEdge ) {
        _isEdge = NO;
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
