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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)buttonClick:(UIButton *)sender {
    //获取button的index值,按照添加的顺序获取
    NSInteger index = [sender.superview.subviews indexOfObject:sender];
    NSLog(@"%ld",(long)index);
    /**
     * 不可以这样直接将one的View加到self.view上，原因是
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
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
