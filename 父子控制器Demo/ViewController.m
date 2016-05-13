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
#import "TempViewController.h"


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
    [self addChildViewController:[[TwoViewController alloc] init]];
    [self addChildViewController:[[ThreeViewController alloc] init]];

    // 将XMGOneViewController从childViewControllers数组中移除
    // [self.childViewControllers[0] removeFromParentViewController];
}


- (IBAction)buttonClick:(UIButton *)sender {
    
    // 移除其他控制器的view
    [self.showingVc.view removeFromSuperview];
    
    // 获得控制器的位置（索引）
    NSUInteger index = [sender.superview.subviews indexOfObject:sender];
    
    // 添加控制器的view
    self.showingVc = self.childViewControllers[index];
    self.showingVc.view.frame = CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height - 64 -200);
    [self.view addSubview:self.showingVc.view];
    
}

/**
 如果OneTableViewController等不是viewController的子控制器，那么导航是传递不到OneTableViewController的；
 验证看touchesBegan：
 
 同样适用于model窗口的弹出和消失；（即如果不具备父子关系，子控制器就不能控制父控制器里面的操作）
 
 */

/**
 * 屏幕即将旋转到某个方向时会调用这个方法
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%@ willRotateToInterfaceOrientation", self.class);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    TempViewController *temp = [[TempViewController alloc] init];
    [self.navigationController pushViewController:temp animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
