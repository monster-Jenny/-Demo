//
//  ViewController.m
//  父子控制器Demo
//
//  Created by monster on 16/5/12.
//  Copyright © 2016年 Monster. All rights reserved.
//

#import "ViewController.h"
#import "OneTableViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "TwoTableViewController.h"



@interface ViewController ()

/** 正在显示的控制器 */
@property (nonatomic, weak) UIViewController *showingVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 通过addChildViewController添加的控制器都会存在于childViewControllers数组中
    [self addChildViewController:[[OneTableViewController alloc] init]];
//    [self addChildViewController:[[TwoViewController alloc] init]];
    [self addChildViewController:[[TwoTableViewController alloc] init]];
    [self addChildViewController:[[ThreeViewController alloc] init]];


    //如果想要子控制器里面的tableView的scrollToTop属性可用，必须将父控制器的scrollView的scrollToTop属性设置为NO；
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.scrollsToTop = NO ;
    [self.view addSubview:scrollView];
    // 将XMGOneViewController从childViewControllers数组中移除
    // [self.childViewControllers[0] removeFromParentViewController];
}


- (IBAction)buttonClick:(UIButton *)sender {
    //获取button的index值,按照添加的顺序获取
//    NSInteger index = [sender.superview.subviews indexOfObject:sender];
//    NSLog(@"%ld",(long)index);
    /**
     * 一、不可以这样直接将one的View加到self.view上，原因是
     * 1、one控制器是局部控制器，会造成控制器已被销毁但是控制器的View还在（在OneTableViewController.m 中dealooc方法会被调用）
     * 2、每次点击button，就会创建一个控制器，重复将新的控制器的view添加到self.view上
     */
    
    /*
    if (index == 0) {
        OneTableViewController * one = [[OneTableViewController alloc] init];
        one.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        [self.view addSubview:one.view];
    }
    */
    
    // 移除其他控制器的view
    [self.showingVc.view removeFromSuperview];
    
    // 获得控制器的位置（索引）
    NSUInteger index = [sender.superview.subviews indexOfObject:sender];
    
    // 添加控制器的view
    self.showingVc = self.childViewControllers[index];
    self.showingVc.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:self.showingVc.view];
    
}

/**
 * 二、想要解决一中出现的两个问题，会考虑将控制器声明成全局变量，只往view上加一次
 * if (self.one == nil) {
 * self.one = [[XMGOneViewController alloc] init];
 * self.one.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
 * }
 * // 添加控制器的view
 * [self.view addSubview:self.one.view];
 * 这样会出现另一个问题：三个控制器会同时出现在self.view上，出现重叠，即使点击one Button的时候，只能看到one控制器的view，但是two和three控制器的view叠在one控制器的下面；这样做的结果就是系统会自动为我们看不见的view分配空间，去渲染；
 */


/**
 * 三、解决二出现的问题：每次添加控制器的view的时候，先将其他的已经添加上的view挪走；
 * // 创建控制器
 * if (self.one == nil) {
 * self.one = [[XMGOneViewController alloc] init];
 * self.one.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
 * }
 * // 移除其他控制器的view
 * [self.two.view removeFromSuperview];
 * [self.three.view removeFromSuperview];
 * // 添加控制器的view
 * [self.view addSubview:self.one.view];
 * 新问题：如果有很多的控制器的view需要挪走，我们需要手动写很多的代码，造成代码的冗余
 */

/**
 * 四、在实现功能的基础上对代码进行重构
 * 首先声明属性
 * 正在显示的控制器
 * @property (nonatomic, weak) UIViewController *showingVc;
 * 存放所有控制器的数组
 * @property (nonatomic, strong) NSArray *allVces;
 *
 * 点击button的时候进行切换
 * // 移除其他控制器的view
 * [self.showingVc.view removeFromSuperview];
 * // 获得控制器的位置（索引）
 * NSUInteger index = [button.superview.subviews indexOfObject:button];
 * // 添加控制器的view
 * self.showingVc = self.allVces[index];
 * self.showingVc.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
 * [self.view addSubview:self.showingVc.view];
 */

/**
 * 五、苹果官方有一句话说的非常好:当控制器的view互为父子关系，那么控制器最好也互为父子关系
 * 在四中我们重构的时候，控制器的view互为父子关系，但是控制器并不是父子关系
 * 这个时候在旋转屏幕的时候会出现新的问题：
 * 我们发现在旋转屏幕的时候，只有viewController在屏幕旋转的时候可以调到屏幕旋转时的方法，OneController等是调用不到屏幕旋转的方法的；
 * 所以我们一定要记住：如果2个控制器的view是父子关系(不管是直接还是间接的父子关系)，那么这2个控制器也应该为父子关系
 * [a.view addSubview:b.view];
 * [a addChildViewController:b];
 * 或者是
 * [a.view addSubview:otherView];
 * [otherView addSubbiew.b.view];
 * [a addChildViewController:b];
 */




/**
 * 当前控制器已经被添加到某个父控制器上时就会调用这个方法
 */


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    
    NSLog(@"didMoveToParentViewController - %@", parent);
}

/**
 * 屏幕即将旋转到某个方向时会调用这个方法
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%@ willRotateToInterfaceOrientation", self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
